import 'dart:async';

import 'package:cliceat_app/core/services/token_service.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:injectable/injectable.dart';

import '../config/env_config.dart';

/// Statuts de connexion WebSocket exposés via [WebSocketService.statusStream].
enum WsStatus { connected, disconnected, reconnecting }

/// Service WebSocket avec reconnexion automatique exponentielle et heartbeat.
///
/// ── Reconnexion ────────────────────────────────────────────────────────────
/// En cas de déconnexion, la reconnexion est tentée avec un backoff
/// exponentiel : 2 s, 4 s, 8 s, 16 s, 32 s (max), jusqu'à [_maxRetries].
/// Le compteur est remis à zéro dès qu'une connexion réussit.
///
/// ── Heartbeat ──────────────────────────────────────────────────────────────
/// Toutes les 25 secondes, un événement `ping` est émis au serveur.
/// Si aucun `pong` n'est reçu dans les 5 secondes suivantes, la connexion
/// est considérée perdue et une reconnexion est déclenchée.
@lazySingleton
class WebSocketService {
  WebSocketService(this._tokenService, this._logger);

  final TokenService _tokenService;
  final Logger _logger;

  io.Socket? _socket;
  bool _manualDisconnect = false;

  // ─── Streams ──────────────────────────────────────────────────────────────

  final _statusController =
      StreamController<WsStatus>.broadcast();
  Stream<WsStatus> get statusStream => _statusController.stream;

  final _missionEventController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get missionEvents =>
      _missionEventController.stream;

  final _orderTrackingEventController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get orderTrackingEvents =>
      _orderTrackingEventController.stream;

  /// Stream temps réel de la position du livreur.
  /// Emis par le backend via l'événement `driver_location_updated`.
  /// Payload attendu: { lat: double, lng: double, orderId: String }
  final _driverLocationController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get driverLocationEvents =>
      _driverLocationController.stream;

  final _chatEventController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get chatEvents => _chatEventController.stream;

  final _authErrorController = StreamController<String>.broadcast();
  Stream<String> get authErrors => _authErrorController.stream;

  // ─── Reconnection state ───────────────────────────────────────────────────

  static const _maxRetries = 8;
  static const _baseBackoffMs = 2000;

  int _retryCount = 0;
  Timer? _reconnectTimer;

  // ─── Heartbeat state ──────────────────────────────────────────────────────

  static const _heartbeatInterval = Duration(seconds: 25);
  static const _pongTimeout = Duration(seconds: 5);

  Timer? _heartbeatTimer;
  Timer? _pongTimeoutTimer;
  bool _waitingForPong = false;

  // ─── Public API ───────────────────────────────────────────────────────────

  bool get isConnected => _socket?.connected == true;

  Future<void> connect() async {
    _manualDisconnect = false;
    if (_socket != null && _socket!.connected) return;
    await _doConnect();
  }

  void disconnect() {
    _manualDisconnect = true;
    _stopReconnect();
    _stopHeartbeat();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _statusController.add(WsStatus.disconnected);
  }

  void emitLocationUpdate(double lat, double lng) {
    if (isConnected) {
      _socket?.emit('delivery_location_update', {'lat': lat, 'lng': lng});
    }
  }

  // ─── Connection logic ─────────────────────────────────────────────────────

  Future<void> _doConnect() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      _logger.w('[WS] Pas de token JWT valide — connexion annulée.');
      _stopReconnect(); // Stop any pending reconnection attempts
      _statusController.add(WsStatus.disconnected);
      return;
    }

    final wsUrl = EnvConfig.wsUrl;

    _socket?.dispose();
    _socket = io.io(
      wsUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.onConnect((_) {
      _logger.i('[WS] Connecté à $wsUrl');
      _retryCount = 0;
      _stopReconnect();
      _statusController.add(WsStatus.connected);
      _startHeartbeat();
    });

    _socket!.on('pong', (_) {
      _logger.d('[WS] Pong reçu.');
      _waitingForPong = false;
      _pongTimeoutTimer?.cancel();
    });

    _socket!.on('mission_dispatched', (data) {
      _logger.i('[WS] Nouvelle mission: $data');
      _missionEventController.add(_toMap(data));
    });

    _socket!.on('order_status_updated', (data) {
      _logger.i('[WS] Statut commande mis à jour: $data');
      _orderTrackingEventController.add(_toMap(data));
    });

    _socket!.on('new_message', (data) {
      _logger.i('[WS] Nouveau message chat: $data');
      _chatEventController.add(_toMap(data));
    });

    // Position livreur en temps réel (client side)
    _socket!.on('driver_location_updated', (data) {
      _logger.d('[WS] Position livreur reçue: $data');
      _driverLocationController.add(_toMap(data));
    });

    _socket!.onDisconnect((_) {
      _logger.w('[WS] Déconnecté.');
      _stopHeartbeat();
      _statusController.add(WsStatus.disconnected);
      _scheduleReconnect();
    });

    _socket!.onConnectError((error) {
      _logger.e('[WS] Erreur de connexion: $error');
      if (error?.toString().contains('revoked') ?? false) {
        _logger.e('[WS] Token révoqué ! Déconnexion forcée.');
        _authErrorController.add(error.toString());
        return;
      }
      _stopHeartbeat();
      _scheduleReconnect();
    });

    _socket!.onError((error) {
      _logger.e('[WS] Erreur: $error');
      if (error?.toString().contains('revoked') ?? false) {
        _authErrorController.add(error.toString());
        return;
      }
      _scheduleReconnect();
    });

    _socket!.connect();
  }

  // ─── Reconnection (exponential backoff) ───────────────────────────────────

  void _scheduleReconnect() {
    if (_manualDisconnect) return;
    if (_reconnectTimer?.isActive == true) return;
    if (_retryCount >= _maxRetries) {
      _logger.e('[WS] Nombre max de tentatives atteint ($_maxRetries). Abandon.');
      return;
    }

    final delayMs = _baseBackoffMs * (1 << _retryCount); // 2s, 4s, 8s...
    _retryCount++;

    _logger.i(
      '[WS] Reconnexion dans ${delayMs}ms (tentative $_retryCount/$_maxRetries)...',
    );
    _statusController.add(WsStatus.reconnecting);

    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () async {
      await _doConnect();
    });
  }

  void _stopReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // ─── Heartbeat ────────────────────────────────────────────────────────────

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (!isConnected) return;

      if (_waitingForPong) {
        // Pas de pong reçu depuis le dernier ping → connexion zombie
        _logger.w('[WS] Pas de pong reçu — reconnexion forcée.');
        _socket?.disconnect();
        return;
      }

      _logger.d('[WS] Ping envoyé.');
      _waitingForPong = true;
      _socket?.emit('ping');

      _pongTimeoutTimer = Timer(_pongTimeout, () {
        if (_waitingForPong) {
          _logger.w('[WS] Timeout pong — connexion considérée perdue.');
          _socket?.disconnect();
        }
      });
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _pongTimeoutTimer?.cancel();
    _pongTimeoutTimer = null;
    _waitingForPong = false;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    return {};
  }
}

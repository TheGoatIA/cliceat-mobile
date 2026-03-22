import 'dart:async';
<<<<<<< HEAD

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

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
class WebSocketService {
  WebSocketService(this._secureStorage, this._logger);

  final FlutterSecureStorage _secureStorage;
  final Logger _logger;

  io.Socket? _socket;

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
    if (_socket != null && _socket!.connected) return;
    await _doConnect();
  }

  void disconnect() {
    _stopReconnect();
    _stopHeartbeat();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _statusController.add(WsStatus.disconnected);
  }

  void emitLocationUpdate(double lat, double lng) {
    if (isConnected) {
=======
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart';

class WebSocketService {
  final FlutterSecureStorage _secureStorage;
  final Logger _logger;
  io.Socket? _socket;

  // Stream controller to broadcast mission events to the UI
  final _missionEventController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get missionEvents => _missionEventController.stream;

  WebSocketService(this._secureStorage, this._logger);

  Future<void> connect() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return;
    
    // We assume the WS server is hosted at the same domain as the API
    final wsUrl = EnvConfig.apiBaseUrl.replaceAll('/api/v1', '');

    _socket = io.io(wsUrl, io.OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNew()
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .build());

    _socket?.onConnect((_) {
      _logger.i('WebSocket Connected via $wsUrl');
    });

    _socket?.on('mission_dispatched', (data) {
      _logger.i('🔔 New Mission Dispatched: $data');
      _missionEventController.add(Map<String, dynamic>.from(data));
    });

    _socket?.on('order_status_updated', (data) {
      _logger.i('📦 Order Status Updated: $data');
      // Should broadcast this as well for ClientTrackingPage
    });

    _socket?.onDisconnect((_) {
      _logger.w('WebSocket Disconnected');
    });
    
    _socket?.onError((error) {
       _logger.e('WebSocket Error: $error');
    });
  }

  void emitLocationUpdate(double lat, double lng) {
    if (_socket != null && _socket!.connected) {
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
      _socket?.emit('delivery_location_update', {'lat': lat, 'lng': lng});
    }
  }

<<<<<<< HEAD
  // ─── Connection logic ─────────────────────────────────────────────────────

  Future<void> _doConnect() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) {
      _logger.w('[WS] Pas de token JWT — connexion annulée.');
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

    _socket!.onDisconnect((_) {
      _logger.w('[WS] Déconnecté.');
      _stopHeartbeat();
      _statusController.add(WsStatus.disconnected);
      _scheduleReconnect();
    });

    _socket!.onError((error) {
      _logger.e('[WS] Erreur: $error');
      _scheduleReconnect();
    });

    _socket!.onConnectError((error) {
      _logger.e('[WS] Erreur de connexion: $error');
      _stopHeartbeat();
      _scheduleReconnect();
    });

    _socket!.connect();
  }

  // ─── Reconnection (exponential backoff) ───────────────────────────────────

  void _scheduleReconnect() {
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
=======
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
  }
}

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

  final _statusController = StreamController<WsStatus>.broadcast();
  Stream<WsStatus> get statusStream => _statusController.stream;

  final _missionEventController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get missionEvents =>
      _missionEventController.stream;

  // Notifié quand un autre driver a accepté avant nous
  final _missionTakenController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get missionTakenEvents =>
      _missionTakenController.stream;

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

  /// Stream des mises à jour d'ETA poussées par le backend.
  /// Payload attendu: { orderId: String, etaMinutes: int }
  final _etaUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get etaUpdateEvents =>
      _etaUpdateController.stream;

  final _chatEventController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get chatEvents => _chatEventController.stream;

  /// Stream for driver navigation step position updates (order:driver_position)
  final _driverNavPositionController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get driverNavPositionEvents =>
      _driverNavPositionController.stream;

  final _authErrorController = StreamController<String>.broadcast();
  Stream<String> get authErrors => _authErrorController.stream;

  // ─── Reconnection state ───────────────────────────────────────────────────

  static const _maxRetries = 8;
  static const _baseBackoffMs = 2000;

  int _retryCount = 0;
  Timer? _reconnectTimer;

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

    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _statusController.add(WsStatus.disconnected);
  }

  void emitLocationUpdate(double lat, double lng, {double? heading}) {
    if (isConnected) {
      _socket?.emit('driver:location', {
        'lat': lat,
        'lng': lng,
        'heading': ?heading,
      });
    }
  }

  void emitNavUpdate({
    required String orderId,
    required int stepIndex,
    required double lat,
    required double lng,
  }) {
    if (isConnected) {
      _socket?.emit('driver:nav_update', {
        'orderId': orderId,
        'stepIndex': stepIndex,
        'lat': lat,
        'lng': lng,
      });
    }
  }

  void joinOrder(String orderId) {
    if (isConnected) {
      _logger.i('[WS] Rejoint le salon de commande: $orderId');
      _socket?.emit('join:order', orderId);
    }
  }

  void leaveOrder(String orderId) {
    if (isConnected) {
      _logger.i('[WS] Quitte le salon de commande: $orderId');
      _socket?.emit('leave:order', orderId);
    }
  }

  // ─── Connection logic ─────────────────────────────────────────────────────

  /// Declenche localement un evenement de rafraichissement du dashboard livreur.
  /// Utilise apres confirmation de livraison pour forcer le rechargement
  /// sans attendre un prochain evenement WebSocket du serveur.
  void triggerLocalMissionRefresh() {
    _missionEventController.add({'type': 'local_refresh'});
  }

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
    });

    _socket!.on('pong', (_) {
      _logger.d('[WS] Pong reçu.');
    });

    _socket!.on('new_mission', (data) {
      _logger.i('[WS] Nouvelle mission: $data');
      _missionEventController.add(_toMap(data));
    });

    _socket!.on('mission_taken', (data) {
      _logger.i('[WS] Mission prise par un autre livreur: $data');
      _missionTakenController.add(_toMap(data));
    });

    _socket!.on('order_status_updated', (data) {
      _logger.i('[WS] Statut commande mis à jour: $data');
      _orderTrackingEventController.add(_toMap(data));
    });

    _socket!.on('driver_assigned', (data) {
      _logger.i('[WS] Livreur assigné: $data');
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

    _socket!.on('driver:location', (data) {
      _logger.d('[WS] Position livreur reçue (room): $data');
      _driverLocationController.add(_toMap(data));
    });

    _socket!.on('driver_location', (data) {
      _logger.d('[WS] Position livreur reçue (driver_location): $data');
      _driverLocationController.add(_toMap(data));
    });

    _socket!.on('eta_updated', (data) {
      _logger.d('[WS] ETA mis à jour: $data');
      _etaUpdateController.add(_toMap(data));
    });

    // Driver navigation step position (Sprint 2 — real-time step forwarding)
    _socket!.on('order:driver_position', (data) {
      _logger.d('[WS] Driver nav position: $data');
      _driverNavPositionController.add(_toMap(data));
      // Also forward to driverLocation stream for map marker update
      _driverLocationController.add(_toMap(data));
    });

    _socket!.on('status_changed', (data) {
      _logger.i('[WS] Statut commande changé (room): $data');
      _orderTrackingEventController.add(_toMap(data));
    });

    _socket!.on('order_status', (data) {
      _logger.i('[WS] Statut client order_status: $data');
      _orderTrackingEventController.add(_toMap(data));
    });

    _socket!.onDisconnect((_) {
      _logger.w('[WS] Déconnecté.');
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
      _logger.e(
        '[WS] Nombre max de tentatives atteint ($_maxRetries). Abandon.',
      );
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

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    return {};
  }
}

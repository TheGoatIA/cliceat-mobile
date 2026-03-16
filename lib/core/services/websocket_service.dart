import 'dart:async';
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

  // Stream controller for order tracking status updates (client-side)
  final _orderTrackingEventController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get orderTrackingEvents => _orderTrackingEventController.stream;

  WebSocketService(this._secureStorage, this._logger);

  bool get isConnected => _socket?.connected == true;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;
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
      _orderTrackingEventController.add(Map<String, dynamic>.from(data));
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
      _socket?.emit('delivery_location_update', {'lat': lat, 'lng': lng});
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}

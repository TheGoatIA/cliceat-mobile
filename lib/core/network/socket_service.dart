import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../config/env_config.dart';

class SocketService {
  final FlutterSecureStorage _storage;

  io.Socket? _ordersSocket;
  io.Socket? _trackingSocket;
  io.Socket? _chatSocket;

  bool _connected = false;
  bool get isConnected => _connected;

  SocketService(this._storage);

  Future<void> connect() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return;

    final opts = io.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .setReconnectionDelay(2000)
        .setReconnectionAttempts(5)
        .enableReconnection()
        .disableAutoConnect()
        .build();

    _ordersSocket = io.io('${EnvConfig.socketBaseUrl}/orders', opts)
      ..onConnect((_) {
        _connected = true;
        debugPrint('[Socket] /orders connected');
      })
      ..onDisconnect((_) {
        _connected = false;
        debugPrint('[Socket] /orders disconnected');
      })
      ..onConnectError((e) => debugPrint('[Socket] /orders error: $e'))
      ..connect();

    _trackingSocket = io.io('${EnvConfig.socketBaseUrl}/tracking', opts)
      ..onConnect((_) => debugPrint('[Socket] /tracking connected'))
      ..onDisconnect((_) => debugPrint('[Socket] /tracking disconnected'))
      ..onConnectError((e) => debugPrint('[Socket] /tracking error: $e'))
      ..connect();

    _chatSocket = io.io('${EnvConfig.socketBaseUrl}/chat', opts)
      ..onConnect((_) => debugPrint('[Socket] /chat connected'))
      ..onDisconnect((_) => debugPrint('[Socket] /chat disconnected'))
      ..onConnectError((e) => debugPrint('[Socket] /chat error: $e'))
      ..connect();
  }

  void disconnect() {
    _ordersSocket?.disconnect();
    _trackingSocket?.disconnect();
    _chatSocket?.disconnect();
    _connected = false;
  }

  void dispose() {
    _ordersSocket?.dispose();
    _trackingSocket?.dispose();
    _chatSocket?.dispose();
  }

  // ---------- Orders namespace ----------
  void onOrderUpdate(void Function(Map<String, dynamic>) handler) {
    _ordersSocket?.on(
        'order:updated', (data) => handler(data as Map<String, dynamic>));
  }

  void onOrderStatusChange(void Function(Map<String, dynamic>) handler) {
    _ordersSocket?.on(
        'order:status', (data) => handler(data as Map<String, dynamic>));
  }

  void offOrderEvents() {
    _ordersSocket?.off('order:updated');
    _ordersSocket?.off('order:status');
  }

  // ---------- Tracking namespace ----------
  void subscribeToOrder(String orderId) {
    _trackingSocket?.emit('subscribe:order', {'orderId': orderId});
  }

  void unsubscribeFromOrder(String orderId) {
    _trackingSocket?.emit('unsubscribe:order', {'orderId': orderId});
  }

  void onDriverLocation(void Function(Map<String, dynamic>) handler) {
    _trackingSocket?.on(
        'driver:location', (data) => handler(data as Map<String, dynamic>));
  }

  void onTrackingUpdate(void Function(Map<String, dynamic>) handler) {
    _trackingSocket?.on(
        'tracking:update', (data) => handler(data as Map<String, dynamic>));
  }

  void offTrackingEvents() {
    _trackingSocket?.off('driver:location');
    _trackingSocket?.off('tracking:update');
  }

  // ---------- Chat namespace ----------
  void joinConversation(String conversationId) {
    _chatSocket?.emit('conversation:join', {'conversationId': conversationId});
  }

  void leaveConversation(String conversationId) {
    _chatSocket?.emit('conversation:leave', {'conversationId': conversationId});
  }

  void onNewMessage(void Function(Map<String, dynamic>) handler) {
    _chatSocket?.on(
        'message:new', (data) => handler(data as Map<String, dynamic>));
  }

  void onMessageRead(void Function(Map<String, dynamic>) handler) {
    _chatSocket?.on(
        'message:read', (data) => handler(data as Map<String, dynamic>));
  }

  void offChatEvents() {
    _chatSocket?.off('message:new');
    _chatSocket?.off('message:read');
  }

  // Emit driver location update (delivery side)
  void emitDriverLocation(double lat, double lng) {
    _trackingSocket?.emit('driver:location', {'lat': lat, 'lng': lng});
  }
}

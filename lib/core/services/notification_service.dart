import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background FCM message: ${message.messageId}");
}

class NotificationService {
  final Logger _logger;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;

  NotificationService(this._logger);

  /// Call once after the router is ready to enable tap-to-route.
  void configureRouting(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i('FCM Push notification permission granted.');
    } else {
      _logger.w('FCM Push notification permission denied.');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _logger.i('Local notification tapped: ${response.payload}');
        // payload is the raw data map stringified — parse orderId if present
        final payload = response.payload ?? '';
        _routeFromPayloadString(payload);
      },
    );

    // Foreground messages → show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('FCM Foreground message: ${message.data}');
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // App opened from background via notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('Notification opened app (background): ${message.data}');
      _routeFromMessage(message);
    });

    // App was terminated — check if opened via notification
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _logger.i('Notification opened app (terminated): ${initial.data}');
      // Delay slightly so the navigator is ready
      Future.delayed(const Duration(milliseconds: 500), () => _routeFromMessage(initial));
    }

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _logger.i('FCM Registration Token: $token');
      }
    } catch (e) {
      _logger.e('Failed to get FCM token: $e');
    }
  }

  /// Returns the FCM registration token for this device, or null on failure.
  Future<String?> getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      _logger.e('Failed to get FCM token: $e');
      return null;
    }
  }

  void _routeFromMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String? ?? '';
    final orderId = data['orderId'] as String? ?? data['order_id'] as String? ?? '';
    _navigate(type, orderId);
  }

  void _routeFromPayloadString(String payload) {
    try {
      // Payload is stored as JSON (from _showLocalNotification)
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final type = data['type'] as String? ?? '';
      final orderId = data['orderId'] as String? ??
          data['order_id'] as String? ?? '';
      _navigate(type, orderId);
    } catch (_) {
      // Legacy fallback: payload stored as Dart map toString()
      final orderIdMatch =
          RegExp(r'orderId:\s*([^\s,}]+)').firstMatch(payload);
      final typeMatch = RegExp(r'type:\s*([^\s,}]+)').firstMatch(payload);
      final orderId = orderIdMatch?.group(1) ?? '';
      final type = typeMatch?.group(1) ?? '';
      _navigate(type, orderId);
    }
  }

  void _navigate(String type, String orderId) {
    final context = _navigatorKey?.currentContext;
    if (context == null || orderId.isEmpty) return;
    final router = GoRouter.of(context);

    switch (type) {
      case 'order_update':
      case 'order_assigned':
      case 'delivery_mission':
        router.push('/client/tracking/$orderId');
      case 'mission_assigned':
        router.push('/delivery/mission/$orderId');
      default:
        if (orderId.isNotEmpty) {
          router.push('/client/tracking/$orderId');
        }
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'cliceat_mission_channel',
      'Missions de Livraison',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: message.notification.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformDetails,
      payload: jsonEncode(message.data),
    );
  }
}

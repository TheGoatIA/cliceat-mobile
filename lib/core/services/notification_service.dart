import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM BG] messageId=${message.messageId}');
}

class NotificationService {
  NotificationService(this._logger);

  final Logger _logger;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;

  // ─── Déduplication ────────────────────────────────────────────────────────
  // Garde en mémoire les messageId déjà affichés pour éviter d'afficher deux
  // fois la même notification (foreground + background race).
  static const _deduplicationWindowMs = 30000; // 30 secondes
  final _recentMessageIds = <String, DateTime>{};

  /// Call once after the router is ready to enable tap-to-route.
  void configureRouting(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  // ─── Initialization ───────────────────────────────────────────────────────

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: false, // criticalAlert nécessite une entitlement Apple
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i('[Notif] Permission accordée.');
    } else {
      _logger.w('[Notif] Permission refusée : ${settings.authorizationStatus}');
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        _logger.i('[Notif] Tap sur notification locale: ${response.payload}');
        _routeFromPayloadString(response.payload ?? '');
      },
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      _logger.i('[Notif] Message foreground: id=${message.messageId}');
      if (!_shouldShow(message)) return;
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // App ouverte depuis l'arrière-plan via tap sur notif
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _logger.i('[Notif] App ouverte depuis background: ${message.data}');
      _routeFromMessage(message);
    });

    // App était fermée (terminée) — vérifier si ouverte via notif
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _logger.i('[Notif] App ouverte depuis état terminé: ${initial.data}');
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _routeFromMessage(initial),
      );
    }

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _logger.i('[Notif] Token FCM obtenu.');
      }
    } catch (e) {
      _logger.e('[Notif] Impossible d\'obtenir le token FCM', error: e);
    }
  }

  /// Returns the FCM registration token for this device, or null on failure.
  Future<String?> getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      _logger.e('[Notif] Impossible d\'obtenir le token FCM', error: e);
      return null;
    }
  }

  // ─── Deduplication ────────────────────────────────────────────────────────

  /// Retourne `true` si le message n'a pas encore été affiché récemment.
  bool _shouldShow(RemoteMessage message) {
    final id = message.messageId;
    if (id == null || id.isEmpty) return true; // Pas d'id → afficher quand même

    _pruneOldEntries();

    if (_recentMessageIds.containsKey(id)) {
      _logger.d('[Notif] Notification dupliquée ignorée : $id');
      return false;
    }

    _recentMessageIds[id] = DateTime.now();
    return true;
  }

  void _pruneOldEntries() {
    final threshold = DateTime.now().subtract(
      Duration(milliseconds: _deduplicationWindowMs),
    );
    _recentMessageIds.removeWhere((_, ts) => ts.isBefore(threshold));
  }

  // ─── Routing ──────────────────────────────────────────────────────────────

  void _routeFromMessage(RemoteMessage message) {
    final type = message.data['type'] as String? ?? '';
    final orderId =
        message.data['orderId'] as String? ??
        message.data['order_id'] as String? ??
        '';
    _navigate(type, orderId);
  }

  void _routeFromPayloadString(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final type = data['type'] as String? ?? '';
      final orderId =
          data['orderId'] as String? ?? data['order_id'] as String? ?? '';
      _navigate(type, orderId);
    } catch (_) {
      final orderIdMatch = RegExp(r'orderId:\s*([^\s,}]+)').firstMatch(payload);
      final typeMatch = RegExp(r'type:\s*([^\s,}]+)').firstMatch(payload);
      _navigate(typeMatch?.group(1) ?? '', orderIdMatch?.group(1) ?? '');
    }
  }

  void _navigate(String type, String orderId) {
    final context = _navigatorKey?.currentContext;
    if (context == null) return;
    final router = GoRouter.of(context);

    switch (type) {
      case 'order_update':
      case 'order_assigned':
      case 'delivery_mission':
        if (orderId.isNotEmpty) router.push('/client/tracking/$orderId');
      case 'mission_assigned':
        if (orderId.isNotEmpty) router.push('/delivery/mission/$orderId');
      default:
        if (orderId.isNotEmpty) router.push('/client/tracking/$orderId');
    }
  }

  // ─── Local notification display ───────────────────────────────────────────

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'cliceat_main_channel',
      'ClicEat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    // Utiliser un ID dérivé du messageId pour l'idempotence côté OS
    final notifId =
        (message.messageId ?? message.sentTime.toString()).hashCode.abs() %
        100000;

    await _localNotifications.show(
      id: notifId,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformDetails,
      payload: jsonEncode(message.data),
    );
  }
}

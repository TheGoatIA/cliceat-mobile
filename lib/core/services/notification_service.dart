import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Logic to process incoming push when app is terminated or backgrounded
  debugPrint("Handling a background FCM message: ${message.messageId}");
}

class NotificationService {
  final Logger _logger;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService(this._logger);

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true, // For delivery missions
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
          _logger.i('Notification tapped from foreground: ${response.payload}');
          // Routing logic to be added
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('FCM Foreground message received: ${message.data}');

      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _logger.i('FCM Registration Token: $token');
        // This token should be sent to Backend via AuthService/UserService
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

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'cliceat_mission_channel', 
      'Missions de Livraison',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true, // Important to wake up for missions
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    int notificationId = message.notification.hashCode;
    
    await _localNotifications.show(
      id: notificationId,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformDetails,
      payload: message.data.toString(),
    );
  }
}

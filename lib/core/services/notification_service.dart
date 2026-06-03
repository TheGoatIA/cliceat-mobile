import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/services/websocket_service.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // En arrière-plan, on utilise debugPrint car le Logger peut ne pas être prêt
  debugPrint('[FCM BG] messageId=${message.messageId}');
}

@lazySingleton
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
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Already requested via FirebaseMessaging.requestPermission
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        _logger.i(
          '[Notif] Tap sur notification locale — payload: ${response.payload}',
        );
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
        if (kDebugMode) {
          _logger.i('[Notif] Token FCM obtenu : $token');
        } else {
          _logger.i('[Notif] Token FCM obtenu.');
        }
      }
    } catch (e) {
      _logger.e('[Notif] Impossible d\'obtenir le token FCM', error: e);
    }

    // Écouter de manière globale les événements de mission WebSocket
    getIt<WebSocketService>().missionEvents.listen((data) {
      final context = _navigatorKey?.currentContext;
      if (context == null || !context.mounted) return;
      try {
        final mission = MissionModel.fromJson(data);
        if (context.mounted) {
          GoRouter.of(context).push('/delivery/incoming', extra: mission);
        }
      } catch (e) {
        _logger.e(
          '[WS Global] Erreur de parsing ou affichage popup mission: $e',
        );
      }
    });

    // Écouter dynamiquement les rafraîchissements de token FCM et les enregistrer en base de données
    _messaging.onTokenRefresh.listen((newToken) async {
      _logger.i('[Notif] Token FCM rafraîchi : $newToken');
      try {
        final authState = getIt<AuthBloc>().state;
        final isLoggedIn = authState.maybeWhen(
          authenticated: (token, userId, currentMode) => true,
          orElse: () => false,
        );
        if (isLoggedIn) {
          final lang = Intl.getCurrentLocale().split('_').first;
          await getIt<UserRepository>().registerFcmToken(newToken, lang: lang);
          _logger.i(
            '[Notif] Nouveau token FCM enregistré suite au rafraîchissement.',
          );
        }
      } catch (e) {
        _logger.w('[Notif] Échec de l\'enregistrement du token rafraîchi: $e');
      }
    });
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

  Future<void> _navigate(String type, String orderId) async {
    int retries = 0;
    while ((_navigatorKey == null || _navigatorKey?.currentContext == null) &&
        retries < 25) {
      await Future.delayed(const Duration(milliseconds: 200));
      retries++;
    }
    final context = _navigatorKey?.currentContext;
    if (context == null || !context.mounted) return;
    final router = GoRouter.of(context);

    switch (type) {
      case 'new_mission':
        router.go('/delivery');
        if (orderId.isNotEmpty) {
          bool dialogOpened = false;
          try {
            // Attendre un tout petit instant pour s'assurer que la route /delivery s'est chargée
            await Future.delayed(const Duration(milliseconds: 150));
            if (!context.mounted) return;

            // Afficher un dialogue de chargement
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryRed),
              ),
            );
            dialogOpened = true;

            // Charger les détails de la commande
            final response = await getIt<OrderService>().getOrderById(orderId);

            // Fermer le dialogue de chargement
            if (dialogOpened && context.mounted) {
              Navigator.of(context).pop();
              dialogOpened = false;
            }

            if (response.isSuccessful &&
                response.body != null &&
                context.mounted) {
              final data =
                  response.body!['data'] as Map<String, dynamic>? ??
                  response.body!;
              final orderData = data['order'] as Map<String, dynamic>? ?? data;
              final mission = MissionModel.fromJson(orderData);

              // Rediriger vers l'écran d'acceptation de la mission
              context.push('/delivery/incoming', extra: mission);
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('delivery.mission_load_error'.tr()),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          } catch (e) {
            if (dialogOpened && context.mounted) {
              Navigator.of(context).pop();
              dialogOpened = false;
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('notifications.mission_load_error'.tr()),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          }
        }
        break;
      case 'order_update':
      case 'order_assigned':
      case 'delivery_mission':
        if (orderId.isNotEmpty) router.push('/client/tracking/$orderId');
        break;
      case 'mission_assigned':
        if (orderId.isNotEmpty) router.push('/delivery/mission/$orderId');
        break;
      case 'promotion':
      case 'marketing':
        router.push('/client/notifications');
        break;
      default:
        if (orderId.isNotEmpty) {
          router.push('/client/tracking/$orderId');
        } else {
          router.push('/client/notifications');
        }
        break;
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

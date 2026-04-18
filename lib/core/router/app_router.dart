import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/client/restaurant/presentation/pages/restaurant_detail_page.dart';
import '../../features/client/cart/presentation/pages/cart_page.dart';
import '../../features/client/checkout/presentation/pages/checkout_page.dart';
import '../../features/client/checkout/presentation/pages/payment_page.dart';
import '../../features/client/tracking/presentation/pages/tracking_page.dart';
import '../../features/client/profile/presentation/pages/profile_page.dart';
import '../../features/chat/presentation/pages/conversations_page.dart';
import '../../features/chat/presentation/pages/conversation_detail_page.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Auth
    GoRoute(path: '/', builder: (_, __) => const SplashPage()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final mode = state.uri.queryParameters['mode'];
        return LoginPage(mode: mode);
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OtpPage(phone: phone);
      },
    ),

    // Client shell
    GoRoute(path: '/client', builder: (_, __) => const ClientMainTab()),

    // Restaurant
    GoRoute(
      path: '/restaurant/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name =
            state.uri.queryParameters['name'] ?? 'Restaurant';
        return RestaurantDetailPage(
            restaurantId: id, restaurantName: name);
      },
    ),

    // Cart
    GoRoute(path: '/cart', builder: (_, __) => const CartPage()),

    // Checkout
    GoRoute(path: '/checkout', builder: (_, __) => const CheckoutPage()),

    // Payment
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PaymentPage(
          paymentUrl: extra['url'] as String? ?? '',
          orderId: extra['orderId'] as String? ?? '',
        );
      },
    ),

    // Tracking
    GoRoute(
      path: '/tracking/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return TrackingPage(orderId: orderId);
      },
    ),

    // Profile
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),

    // Chat
    GoRoute(
        path: '/chat', builder: (_, __) => const ConversationsPage()),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final title = state.extra as String? ?? 'Conversation';
        return ConversationDetailPage(
            conversationId: id, title: title);
      },
    ),

    // Delivery
    GoRoute(path: '/delivery', builder: (_, __) => const DeliveryMainTab()),
  ],
);

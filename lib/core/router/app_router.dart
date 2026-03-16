import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/client/restaurant/presentation/pages/restaurant_detail_page.dart';
import '../../features/client/cart/presentation/pages/checkout_page.dart';
import '../../features/client/cart/presentation/pages/client_tracking_page.dart';
import '../../features/client/cart/presentation/pages/order_success_page.dart';
import '../../features/client/cart/presentation/pages/payment_webview_page.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash — handles auth check and redirects
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    // ── Client routes ────────────────────────────────────────────────────────
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientMainTab(),
      routes: [
        GoRoute(
          path: 'tracking/:orderId',
          builder: (context, state) => ClientTrackingPage(
            orderId: state.pathParameters['orderId']!,
          ),
        ),
        GoRoute(
          path: 'order-success/:orderId',
          builder: (context, state) => OrderSuccessPage(
            orderId: state.pathParameters['orderId']!,
          ),
        ),
        GoRoute(
          path: 'payment',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>? ?? {};
            return PaymentWebviewPage(
              paymentUrl: extra['paymentUrl'] ?? '',
              orderId: extra['orderId'] ?? '',
            );
          },
        ),
      ],
    ),

    // Restaurant detail (accessible from map, home, search)
    GoRoute(
      path: '/restaurant/:id',
      builder: (context, state) => RestaurantDetailPage(
        restaurantId: state.pathParameters['id']!,
      ),
    ),

    // Checkout (full screen, outside tab shell)
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),

    // ── Delivery routes ───────────────────────────────────────────────────────
    GoRoute(
      path: '/delivery',
      builder: (context, state) => const DeliveryMainTab(),
    ),
  ],
);

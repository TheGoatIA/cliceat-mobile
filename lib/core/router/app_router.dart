import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/client/home/presentation/pages/search_results_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/client/restaurant/presentation/pages/restaurant_detail_page.dart';
import '../../features/client/cart/presentation/pages/cart_page.dart';
import '../../features/client/cart/presentation/pages/checkout_page.dart';
import '../../features/client/cart/presentation/pages/client_tracking_page.dart';
import '../../features/client/cart/presentation/pages/order_success_page.dart';
import '../../features/client/cart/presentation/pages/payment_webview_page.dart';
import '../../features/client/cart/presentation/pages/address_selection_page.dart';
import '../../features/client/cart/presentation/pages/order_history_page.dart';
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

    GoRoute(
      path: '/auth/login',
      builder: (context, state) {
        final mode = state.uri.queryParameters['mode'] ?? 'client';
        return LoginPage(mode: mode);
      },
    ),

    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return ResetPasswordPage(token: token);
      },
    ),

    GoRoute(
      path: '/auth/verify-email',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailVerificationPage(email: email);
      },
    ),

    // ── Client routes ────────────────────────────────────────────────────────
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientMainTab(),
      routes: [
        GoRoute(
          path: 'cart',
          builder: (context, state) => const CartPage(),
        ),
        GoRoute(
          path: 'address-selection',
          builder: (context, state) => const AddressSelectionPage(),
        ),
        GoRoute(
          path: 'orders',
          builder: (context, state) => const OrderHistoryPage(),
        ),
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

    // Dedicated search results page
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return SearchResultsPage(initialQuery: query);
      },
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

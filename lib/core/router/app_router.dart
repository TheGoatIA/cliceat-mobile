import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/client/restaurant/presentation/pages/restaurant_detail_page.dart';
import '../../features/client/cart/presentation/pages/cart_page.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';
import '../../features/client/cart/presentation/pages/payment_webview_page.dart';
import '../../features/client/cart/presentation/pages/checkout_page.dart';
import '../../features/client/cart/presentation/pages/address_selection_page.dart';
import '../../features/client/cart/presentation/pages/order_success_page.dart';
import '../../features/client/cart/presentation/pages/client_tracking_page.dart';
import '../../features/delivery/dashboard/presentation/pages/mission_incoming_page.dart';
import '../../features/delivery/dashboard/presentation/pages/active_navigation_page.dart';
import '../../features/delivery/dashboard/presentation/pages/confirm_pickup_page.dart';
import '../../features/delivery/dashboard/presentation/pages/dropoff_page.dart';
import '../../features/client/profile/presentation/pages/order_history_page.dart';
import '../../features/client/cart/presentation/pages/order_rating_page.dart';
import '../../features/delivery/dashboard/presentation/pages/report_issue_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    // Basic Authentication Guard
    // The exact bloc state isn't synchronous but we can access it via getIt
    final authBloc = getIt<AuthBloc>();
    final isAuth = authBloc.state.maybeWhen(
      authenticated: (token, userId, mode) => true,
      orElse: () => false,
    );
    
    final isGoingToLogin = state.matchedLocation == '/login' || state.matchedLocation == '/otp' || state.matchedLocation == '/register';
    final isSplash = state.matchedLocation == '/';
    
    // Si l'utilisateur n'est pas authentifié et n'est pas sur une page publique
    if (!isAuth && !isGoingToLogin && !isSplash) {
      return '/login';
    }
    
    // Si l'utilisateur est authentifié et essaie d'aller sur une page publique
    if (isAuth && isGoingToLogin) {
      return '/onboarding'; // Let them pick mode
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.extra as String?;
        return OtpPage(phone: phone ?? '');
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) => const ClientMainTab(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/restaurant/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return RestaurantDetailPage(restaurantId: id);
      },
    ),
    GoRoute(
      path: '/delivery',
      builder: (context, state) => const DeliveryMainTab(),
    ),
    GoRoute(
      path: '/delivery/incoming-mission',
      builder: (context, state) => const MissionIncomingPage(),
    ),
    GoRoute(
      path: '/delivery/navigation',
      builder: (context, state) => const ActiveNavigationPage(),
    ),
    GoRoute(
      path: '/delivery/confirm-pickup',
      builder: (context, state) => const ConfirmPickupPage(),
    ),
    GoRoute(
      path: '/delivery/dropoff',
      builder: (context, state) => const DropoffPage(),
    ),
    GoRoute(
      path: '/delivery/report-issue/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ReportIssuePage(missionId: id);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/address-selection',
      builder: (context, state) => const AddressSelectionPage(),
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) {
        final orderId = state.extra as String? ?? 'UNKNOWN';
        return OrderSuccessPage(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/client/tracking/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ClientTrackingPage(orderId: id);
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final url = state.extra as String?;
        if (url == null) {
          return const Scaffold(body: Center(child: Text('Invalid Payment URL')));
        }
        return PaymentWebViewPage(paymentUrl: url);
      },
    ),
    GoRoute(
      path: '/order-history',
      builder: (context, state) => const OrderHistoryPage(),
    ),
    GoRoute(
      path: '/order-rating/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return OrderRatingPage(orderId: id);
      },
    ),
  ],
);

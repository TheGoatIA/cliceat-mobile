import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingPage(),
    ),
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
    GoRoute(
      path: '/client',
      builder: (_, __) => const ClientMainTab(),
    ),
    GoRoute(
      path: '/delivery',
      builder: (_, __) => const DeliveryMainTab(),
    ),
  ],
);

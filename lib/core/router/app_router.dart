import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
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
      path: '/delivery',
      builder: (context, state) => const DeliveryMainTab(),
    ),
  ],
);

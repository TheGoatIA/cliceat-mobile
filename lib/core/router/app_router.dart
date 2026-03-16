import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/client/restaurant/presentation/pages/restaurant_detail_page.dart';
import '../../features/client/cart/presentation/pages/cart_page.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';

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
    
    final isGoingToLogin = state.matchedLocation == '/login' || state.matchedLocation == '/otp';
    final isSplash = state.matchedLocation == '/';
    
    // Si l'utilisateur n'est pas authentifié et n'est pas sur une page publique
    if (!isAuth && !isGoingToLogin && !isSplash) {
      return '/login';
    }
    
    // Si l'utilisateur est authentifié et essaie d'aller sur login
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
  ],
);

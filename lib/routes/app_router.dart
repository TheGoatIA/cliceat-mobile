import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/client/home/presentation/pages/client_main_tab.dart';
import '../../features/client/home/presentation/pages/search_results_page.dart';
import '../../features/client/restaurant/presentation/pages/restaurant_detail_page.dart';
import '../../features/client/cart/presentation/pages/cart_page.dart';
import '../../features/client/cart/presentation/pages/checkout_page.dart';
import '../../features/client/cart/presentation/pages/client_tracking_page.dart';
import '../../features/client/cart/presentation/pages/order_success_page.dart';
import '../../features/client/cart/presentation/pages/payment_webview_page.dart';
import '../../features/client/cart/presentation/pages/address_selection_page.dart';
import '../../features/client/cart/presentation/pages/order_history_page.dart';
import '../../features/client/cart/presentation/pages/order_rating_page.dart';
import '../../features/delivery/dashboard/presentation/pages/delivery_main_tab.dart';
import '../../features/delivery/dashboard/presentation/pages/active_navigation_page.dart';
import '../../features/delivery/dashboard/presentation/pages/confirm_pickup_page.dart';
import '../../features/delivery/dashboard/presentation/pages/dropoff_page.dart';
import '../../features/delivery/dashboard/presentation/pages/mission_incoming_page.dart';
import '../../features/delivery/dashboard/presentation/pages/payout_page.dart';
import '../../features/delivery/dashboard/presentation/bloc/mission_bloc.dart';
import '../../features/delivery/dashboard/data/models/mission_model.dart';
import '../../features/legal/presentation/pages/terms_page.dart';
import '../../features/legal/presentation/pages/privacy_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/chat/data/models/chat_model.dart';
import '../../features/client/referral/presentation/pages/referral_page.dart';
import '../../features/client/ai/presentation/pages/ai_assistant_page.dart';
import '../../features/client/review/presentation/pages/my_reviews_page.dart';
import '../../features/client/wallet/presentation/pages/wallet_page.dart';
import '../../features/client/dispute/presentation/pages/create_dispute_page.dart';
import '../../features/client/dispute/presentation/pages/dispute_history_page.dart';
import '../../features/delivery/wallet/presentation/pages/delivery_wallet_page.dart';
import '../../features/client/ai/presentation/cubit/ai_cubit.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/client/referral/presentation/cubit/referral_cubit.dart';
import '../../features/client/review/presentation/cubit/review_cubit.dart';
import '../../core/di/injection.dart';
import '../../features/client/notification/presentation/pages/notifications_page.dart';
import '../../features/client/notification/presentation/cubit/notification_cubit.dart';
import 'package:cliceat_app/shared/pages/map_picker_page.dart';
import 'package:cliceat_app/core/config/presentation/bloc/config_bloc.dart';
import 'package:cliceat_app/core/widgets/maintenance_page.dart';
import 'package:cliceat_app/core/widgets/force_update_page.dart';
import 'package:cliceat_app/core/config/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io' show Platform;

import 'dart:async';

// ─── Navigator key ────────────────────────────────────────────────────────────

final rootNavigatorKey = GlobalKey<NavigatorState>();

// ─── Refresh Listenable ───────────────────────────────────────────────────────

/// Helper class to convert one or more Streams into a Listenable for GoRouter.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(
    Stream<dynamic> stream, {
    List<Stream<dynamic>> extra = const [],
  }) {
    _subscription = stream.listen((dynamic _) => notifyListeners());
    _extraSubscriptions = extra
        .map((s) => s.listen((dynamic _) => notifyListeners()))
        .toList();
  }

  late final StreamSubscription<dynamic> _subscription;
  late final List<StreamSubscription<dynamic>> _extraSubscriptions;

  @override
  void dispose() {
    _subscription.cancel();
    for (final s in _extraSubscriptions) {
      s.cancel();
    }
    super.dispose();
  }
}

// ─── Route names (constants to avoid typos) ───────────────────────────────────

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const verifyEmail = '/auth/verify-email';
  static const client = '/client';
  static const search = '/search';
  static const restaurant = '/restaurant/:id';
  static const checkout = '/checkout';
  static const delivery = '/delivery';
  static const orderSuccess = '/client/order-success/:orderId';
  static const tracking = '/client/tracking/:orderId';
  static const payment = '/client/payment';
  static const terms = '/legal/terms';
  static const privacy = '/legal/privacy';
  static const maintenance = '/maintenance';
  static const update = '/update';
  static const mapPicker = '/map-picker';
}

// ─── Public routes (accessible without authentication) ────────────────────────

const _kPublicRoutes = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
  AppRoutes.resetPassword,
  AppRoutes.verifyEmail,
  AppRoutes.terms,
  AppRoutes.privacy,
  AppRoutes.maintenance,
  AppRoutes.update,
};

// ─── Role-based redirect logic ────────────────────────────────────────────────

bool _isVersionBelow(String current, String? minRequired) {
  if (minRequired == null || minRequired.isEmpty) return false;

  final currentParts = current.split('+')[0].split('.');
  final minParts = minRequired.split('+')[0].split('.');

  for (int i = 0; i < 3; i++) {
    final currentPart = i < currentParts.length
        ? int.tryParse(currentParts[i]) ?? 0
        : 0;
    final minPart = i < minParts.length ? int.tryParse(minParts[i]) ?? 0 : 0;

    if (currentPart < minPart) return true;
    if (currentPart > minPart) return false;
  }
  return false;
}

/// Retourne le chemin de redirection si l'utilisateur n'est pas autorisé,
/// ou `null` si la navigation est permise.
String? _guardRedirect(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthBloc>().state;
  final configState = context.read<ConfigBloc>().state;
  final location = state.matchedLocation;

  // 1. Check Maintenance Mode
  final isMaintenance = configState.maybeWhen(
    loaded: (c) => c.maintenanceMode,
    orElse: () => false,
  );

  if (isMaintenance && location != AppRoutes.maintenance) {
    return AppRoutes.maintenance;
  }
  if (!isMaintenance && location == AppRoutes.maintenance) {
    return AppRoutes.splash;
  }

  // 2. Check Force Update
  final needsUpdate = configState.maybeWhen(
    loaded: (c) {
      if (!c.forceUpdate) return false;
      final currentVersion = AppConstants.appVersion;
      final minVersion = Platform.isIOS ? c.iosMinVersion : c.androidMinVersion;
      return _isVersionBelow(currentVersion, minVersion);
    },
    orElse: () => false,
  );

  if (needsUpdate && location != AppRoutes.update) {
    return AppRoutes.update;
  }
  if (!needsUpdate && location == AppRoutes.update) {
    return AppRoutes.splash;
  }

  // Ignorer les routes publiques
  if (_kPublicRoutes.any(
    (r) => location.startsWith(r) && r != AppRoutes.splash,
  )) {
    return null;
  }
  if (location == AppRoutes.splash) return null;

  return authState.when(
    initial: () => null, // SplashPage gère la redirection initiale
    loading: () => null,
    unauthenticated: () {
      // Pas authentifié → login
      final mode = location.startsWith('/delivery') ? 'delivery' : 'client';
      return '${AppRoutes.login}?mode=$mode';
    },
    authenticated: (token, userId, currentMode) {
      // Accès /client quand mode = delivery → rediriger vers /delivery
      if (location.startsWith('/client') && currentMode == 'delivery') {
        return AppRoutes.delivery;
      }
      // Accès /delivery quand mode = client → rediriger vers /client
      if (location.startsWith('/delivery') && currentMode == 'client') {
        return AppRoutes.client;
      }
      return null; // Autorisé
    },
    otpSent: (_) => null,
    emailVerificationRequired: (_) => null,
    emailVerified: () => null,
    forgotPasswordEmailSent: (_) => null,
    resetPasswordSuccess: () => null,
    driverRegistrationSuccess: () => null,
    error: (_) => null,
  );
}

MissionModel _parseMission(Object? extra) {
  if (extra is MissionModel) {
    return extra;
  }
  if (extra is Map<String, dynamic>) {
    return MissionModel.fromJson(extra);
  }
  if (extra is Map) {
    return MissionModel.fromJson(Map<String, dynamic>.from(extra));
  }
  throw Exception('Invalid mission extra: $extra');
}

// ─── Router ───────────────────────────────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  refreshListenable: GoRouterRefreshStream(
    getIt<AuthBloc>().stream,
    extra: [getIt<ConfigBloc>().stream],
  ),
  redirect: _guardRedirect,
  routes: [
    // Splash — gère le check d'auth et redirige
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        final mode = state.uri.queryParameters['mode'] ?? 'client';
        return LoginPage(mode: mode);
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return RegisterPage(initialRole: role);
      },
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return ResetPasswordPage(token: token);
      },
    ),

    GoRoute(
      path: AppRoutes.verifyEmail,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailVerificationPage(email: email);
      },
    ),

    // ── Client routes ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.client,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ClientMainTab(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
      routes: [
        GoRoute(
          path: 'ai',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<AiCubit>()..loadOrCreateConversation(),
            child: const AiAssistantPage(),
          ),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<NotificationCubit>(),
            child: const NotificationsPage(),
          ),
        ),
        GoRoute(
          path: 'chat',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<ChatCubit>()..loadConversations(),
            child: const ChatListPage(),
          ),
        ),
        GoRoute(
          path: 'chat/:id',
          builder: (context, state) {
            final conv = state.extra as ConversationModel;
            return BlocProvider(
              create: (context) => getIt<ChatCubit>(),
              child: ChatDetailPage(conversation: conv),
            );
          },
        ),
        GoRoute(
          path: 'profile/referrals',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<ReferralCubit>()..loadStats(),
            child: const ReferralPage(),
          ),
        ),
        GoRoute(
          path: 'profile/reviews',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<ReviewCubit>()..loadMyReviews(),
            child: const MyReviewsPage(),
          ),
        ),
        GoRoute(
          path: 'wallet',
          builder: (context, state) => const WalletPage(),
        ),
        GoRoute(
          path: 'dispute/history',
          builder: (context, state) => const DisputeHistoryPage(),
        ),
        GoRoute(
          path: 'dispute/create/:orderId',
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return CreateDisputePage(orderId: orderId);
          },
        ),
        GoRoute(path: 'cart', builder: (context, state) => const CartPage()),
        GoRoute(
          path: 'address-selection',
          builder: (context, state) => const AddressSelectionPage(),
        ),
        GoRoute(
          path: 'orders',
          builder: (context, state) => const OrderHistoryPage(),
        ),
        GoRoute(
          path: 'rate/:orderId',
          builder: (context, state) =>
              OrderRatingPage(orderId: state.pathParameters['orderId']!),
        ),
      ],
    ),

    // ── Order & Payment routes (Top-level for easy access) ──────────────────
    GoRoute(
      path: AppRoutes.tracking,
      builder: (context, state) =>
          ClientTrackingPage(orderId: state.pathParameters['orderId']!),
    ),
    GoRoute(
      path: '/client/order-success/:orderId',
      builder: (context, state) =>
          OrderSuccessPage(orderId: state.pathParameters['orderId'] ?? ''),
    ),
    // Fallback for missing orderId
    GoRoute(
      path: '/client/order-success',
      builder: (context, state) => const OrderSuccessPage(orderId: ''),
    ),
    GoRoute(
      path: AppRoutes.payment,
      builder: (context, state) {
        final extra = state.extra as Map?;
        return PaymentWebviewPage(
          paymentUrl: extra?['paymentUrl']?.toString() ?? '',
          orderId: extra?['orderId']?.toString() ?? '',
          isWalletRecharge: extra?['isWalletRecharge'] == true,
        );
      },
    ),

    // Résultats de recherche (accessible depuis le shell client)
    GoRoute(
      path: AppRoutes.search,
      pageBuilder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        final city = state.uri.queryParameters['city'] ?? 'Yaound\u00e9';
        return CustomTransitionPage(
          key: state.pageKey,
          child: SearchResultsPage(initialQuery: query, city: city),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
        );
      },
    ),

    // Détail restaurant (accessible depuis carte, accueil, recherche)
    GoRoute(
      path: AppRoutes.restaurant,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: RestaurantDetailPage(restaurantId: state.pathParameters['id']!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ),

    // Checkout (plein écran, hors tab shell)
    GoRoute(
      path: AppRoutes.checkout,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CheckoutPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ),

    // ── Delivery routes ───────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.delivery,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DeliveryMainTab(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
      routes: [
        GoRoute(
          path: 'incoming',
          builder: (context, state) {
            final mission = _parseMission(state.extra);
            return BlocProvider<MissionBloc>(
              create: (context) => getIt<MissionBloc>(),
              child: MissionIncomingPage(mission: mission),
            );
          },
        ),
        GoRoute(
          path: 'payouts',
          builder: (context, state) => const PayoutPage(),
        ),
        GoRoute(
          path: 'active-navigation',
          builder: (context, state) {
            final mission = _parseMission(state.extra);
            return ActiveNavigationPage(mission: mission);
          },
        ),
        GoRoute(
          path: 'confirm-pickup',
          builder: (context, state) {
            final mission = _parseMission(state.extra);
            return BlocProvider<MissionBloc>(
              create: (context) => getIt<MissionBloc>(),
              child: ConfirmPickupPage(mission: mission),
            );
          },
        ),
        GoRoute(
          path: 'dropoff',
          builder: (context, state) {
            final mission = _parseMission(state.extra);
            return BlocProvider<MissionBloc>(
              create: (context) => getIt<MissionBloc>(),
              child: DropoffPage(mission: mission),
            );
          },
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<NotificationCubit>(),
            child: const NotificationsPage(),
          ),
        ),
        GoRoute(
          path: 'wallet',
          builder: (context, state) => const DeliveryWalletPage(),
        ),
      ],
    ),

    // ── Legal routes (publiques) ───────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.terms,
      builder: (context, state) => const TermsPage(),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      builder: (context, state) => const PrivacyPage(),
    ),
    GoRoute(
      path: AppRoutes.maintenance,
      builder: (context, state) {
        final config = context.read<ConfigBloc>().state.maybeWhen(
          loaded: (c) => c,
          orElse: () => null,
        );
        final locale = context.locale.languageCode;
        final msg = locale == 'en'
            ? config?.maintenanceMessageEn
            : config?.maintenanceMessageFr;
        return MaintenancePage(message: msg);
      },
    ),
    GoRoute(
      path: AppRoutes.update,
      builder: (context, state) {
        final config = context.read<ConfigBloc>().state.maybeWhen(
          loaded: (c) => c,
          orElse: () => null,
        );
        final locale = context.locale.languageCode;
        final msg = locale == 'en'
            ? config?.updateMessageEn
            : config?.updateMessageFr;
        final updateUrl = Platform.isIOS
            ? config?.iosUpdateUrl
            : config?.updateUrl;
        return ForceUpdatePage(message: msg, updateUrl: updateUrl);
      },
    ),
    GoRoute(
      path: AppRoutes.mapPicker,
      builder: (context, state) {
        final Map<String, dynamic>? args = state.extra as Map<String, dynamic>?;
        return MapPickerPage(
          initialLat: args?['initialLat'] as double?,
          initialLng: args?['initialLng'] as double?,
        );
      },
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
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

// ─── Navigator key ────────────────────────────────────────────────────────────

final rootNavigatorKey = GlobalKey<NavigatorState>();

// ─── Route names (constants to avoid typos) ───────────────────────────────────

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const verifyEmail = '/auth/verify-email';
  static const client = '/client';
  static const search = '/search';
  static const restaurant = '/restaurant/:id';
  static const checkout = '/checkout';
  static const delivery = '/delivery';
  static const terms = '/legal/terms';
  static const privacy = '/legal/privacy';
}

// ─── Public routes (accessible without authentication) ────────────────────────

const _kPublicRoutes = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.forgotPassword,
  AppRoutes.resetPassword,
  AppRoutes.verifyEmail,
  AppRoutes.terms,
  AppRoutes.privacy,
};

// ─── Role-based redirect logic ────────────────────────────────────────────────

/// Retourne le chemin de redirection si l'utilisateur n'est pas autorisé,
/// ou `null` si la navigation est permise.
String? _guardRedirect(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthBloc>().state;
  final location = state.matchedLocation;

  // Ignorer les routes publiques
  if (_kPublicRoutes.any((r) => location.startsWith(r) && r != AppRoutes.splash)) {
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
    error: (_) => null,
  );
}

// ─── Router ───────────────────────────────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
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
      builder: (context, state) => const ClientMainTab(),
      routes: [
        GoRoute(
          path: 'ai',
          builder: (context, state) => const AiAssistantPage(),
        ),
        GoRoute(
          path: 'chat',
          builder: (context, state) => const ChatListPage(),
        ),
        GoRoute(
          path: 'chat/:id',
          builder: (context, state) {
            final conv = state.extra as ConversationModel;
            return ChatDetailPage(conversation: conv);
          },
        ),
        GoRoute(
          path: 'profile/referrals',
          builder: (context, state) => const ReferralPage(),
        ),
        GoRoute(
          path: 'profile/reviews',
          builder: (context, state) => const MyReviewsPage(),
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
          path: 'rate/:orderId',
          builder: (context, state) => OrderRatingPage(
            orderId: state.pathParameters['orderId']!,
          ),
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

    // Résultats de recherche (accessible depuis le shell client)
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return SearchResultsPage(initialQuery: query);
      },
    ),

    // Détail restaurant (accessible depuis carte, accueil, recherche)
    GoRoute(
      path: AppRoutes.restaurant,
      builder: (context, state) => RestaurantDetailPage(
        restaurantId: state.pathParameters['id']!,
      ),
    ),

    // Checkout (plein écran, hors tab shell)
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) => const CheckoutPage(),
    ),

    // ── Delivery routes ───────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.delivery,
      builder: (context, state) => const DeliveryMainTab(),
      routes: [
        GoRoute(
          path: 'incoming',
          builder: (context, state) {
            final mission = state.extra as MissionModel;
            return MissionIncomingPage(mission: mission);
          },
        ),
        GoRoute(
          path: 'payouts',
          builder: (context, state) => const PayoutPage(),
        ),
        GoRoute(
          path: 'active-navigation',
          builder: (context, state) {
            final mission = state.extra as MissionModel;
            return ActiveNavigationPage(mission: mission);
          },
        ),
        GoRoute(
          path: 'confirm-pickup',
          builder: (context, state) {
            final mission = state.extra as MissionModel;
            return ConfirmPickupPage(mission: mission);
          },
        ),
        GoRoute(
          path: 'dropoff',
          builder: (context, state) {
            final mission = state.extra as MissionModel;
            return DropoffPage(mission: mission);
          },
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
  ],
);

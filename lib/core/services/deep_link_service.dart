import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import 'package:injectable/injectable.dart';

/// Handles incoming deep links and routes them to the correct page.
///
/// Supported schemes:
///   cliceat://reset-password?token=XXX       → /auth/reset-password?token=XXX
///   cliceat://verify-email?token=XXX         → /auth/verify-email?token=XXX
///   cliceat://restaurant/RESTAURANT_ID       → /restaurant/RESTAURANT_ID
///   cliceat://order/ORDER_ID                 → /client/tracking/ORDER_ID
///   https://cliceat.cm/reset-password?token= → /auth/reset-password?token=XXX
///   https://cliceat.cm/verify-email?token=   → /auth/verify-email?token=XXX
///   https://cliceat.cm/restaurant/ID         → /restaurant/ID
@lazySingleton
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final Logger _logger;
  StreamSubscription<Uri>? _sub;

  DeepLinkService(this._logger);

  /// Call once after runApp and router are ready.
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // Handle the initial link (app was opened via a link while terminated)
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        _logger.i('Initial deep link: $initial');
        _handleUri(initial, navigatorKey);
      }
    } catch (e) {
      _logger.e('Failed to get initial deep link: $e');
    }

    // Listen to all subsequent links (app already running)
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _logger.i('Incoming deep link: $uri');
        _handleUri(uri, navigatorKey);
      },
      onError: (e) => _logger.e('Deep link stream error: $e'),
    );
  }

  void _handleUri(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final router = GoRouter.of(context);
    final query = uri.queryParameters;
    var path = uri.path.replaceFirst(RegExp(r'^/+'), '');

    // Handle backend-prefixed paths (e.g., from api.cliceat.cm/api/auth/...)
    if (path.startsWith('api/auth/')) {
      path = path.substring('api/auth/'.length);
    }

    // cliceat://reset-password?token=XXX  or  /reset-password?token=XXX
    if (path == 'reset-password') {
      final token = query['token'];
      if (token != null && token.isNotEmpty) {
        router.go('/auth/reset-password?token=${Uri.encodeComponent(token)}');
        return;
      }
    }

    // cliceat://verify-email?token=XXX  or  /verify-email?token=XXX
    if (path == 'verify-email') {
      final token = query['token'];
      if (token != null && token.isNotEmpty) {
        router.go('/auth/verify-email?token=${Uri.encodeComponent(token)}');
        return;
      }
      // cliceat://verify-email?email=XXX (from registration flow)
      final email = query['email'];
      if (email != null && email.isNotEmpty) {
        router.go('/auth/verify-email?email=${Uri.encodeComponent(email)}');
        return;
      }
    }

    // cliceat://restaurant/RESTAURANT_ID
    if (path.startsWith('restaurant/')) {
      final id = path.substring('restaurant/'.length);
      if (id.isNotEmpty) {
        router.go('/restaurant/$id');
        return;
      }
    }

    // cliceat://order/ORDER_ID
    if (path.startsWith('order/')) {
      final id = path.substring('order/'.length);
      if (id.isNotEmpty) {
        router.go('/client/tracking/$id');
        return;
      }
    }

    // cliceat://open → just open the app (no-op, already open)
    _logger.w('Unhandled deep link: $uri');
  }

  void dispose() {
    _sub?.cancel();
  }
}

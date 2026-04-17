import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Centralised Firebase Analytics wrapper.
/// All analytics events in the app should go through this service.
@lazySingleton
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  final Logger _logger;

  AnalyticsService(this._logger)
      : _analytics = FirebaseAnalytics.instance;

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<void> logLogin(String method) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      _logger.w('Analytics logLogin failed: $e');
    }
  }

  Future<void> logSignUp(String method) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
    } catch (e) {
      _logger.w('Analytics logSignUp failed: $e');
    }
  }

  Future<void> logLogout() async {
    try {
      await _analytics.logEvent(name: 'logout');
    } catch (e) {
      _logger.w('Analytics logLogout failed: $e');
    }
  }

  // ─── Restaurant discovery ─────────────────────────────────────────────────

  Future<void> logRestaurantViewed(
      String restaurantId, String name) async {
    try {
      await _analytics.logViewItem(
        currency: 'XAF',
        items: [
          AnalyticsEventItem(
            itemId: restaurantId,
            itemName: name,
            itemCategory: 'restaurant',
          ),
        ],
      );
    } catch (e) {
      _logger.w('Analytics logRestaurantViewed failed: $e');
    }
  }

  Future<void> logSearchPerformed(String query) async {
    try {
      await _analytics.logSearch(searchTerm: query);
    } catch (e) {
      _logger.w('Analytics logSearchPerformed failed: $e');
    }
  }

  // ─── Cart ─────────────────────────────────────────────────────────────────

  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required double price,
    required String restaurantId,
  }) async {
    try {
      await _analytics.logAddToCart(
        currency: 'XAF',
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            price: price,
          ),
        ],
      );
    } catch (e) {
      _logger.w('Analytics logAddToCart failed: $e');
    }
  }

  Future<void> logViewCart(double total) async {
    try {
      await _analytics.logViewCart(currency: 'XAF', value: total);
    } catch (e) {
      _logger.w('Analytics logViewCart failed: $e');
    }
  }

  // ─── Checkout & payment ───────────────────────────────────────────────────

  Future<void> logBeginCheckout(double total) async {
    try {
      await _analytics.logBeginCheckout(currency: 'XAF', value: total);
    } catch (e) {
      _logger.w('Analytics logBeginCheckout failed: $e');
    }
  }

  Future<void> logPaymentInitiated(
      double amount, String method) async {
    try {
      await _analytics.logEvent(
        name: 'payment_initiated',
        parameters: {
          'currency': 'XAF',
          'value': amount,
          'payment_method': method,
        },
      );
    } catch (e) {
      _logger.w('Analytics logPaymentInitiated failed: $e');
    }
  }

  Future<void> logPurchase({
    required String orderId,
    required double total,
    double? deliveryFee,
    String? coupon,
  }) async {
    try {
      await _analytics.logPurchase(
        transactionId: orderId,
        currency: 'XAF',
        value: total,
        shipping: deliveryFee,
        coupon: coupon,
      );
    } catch (e) {
      _logger.w('Analytics logPurchase failed: $e');
    }
  }

  Future<void> logOrderCancelled(String orderId) async {
    try {
      await _analytics.logRefund(
        transactionId: orderId,
        currency: 'XAF',
      );
    } catch (e) {
      _logger.w('Analytics logOrderCancelled failed: $e');
    }
  }

  // ─── Delivery driver ──────────────────────────────────────────────────────

  Future<void> logDriverOnline(bool isOnline) async {
    try {
      await _analytics.logEvent(
        name: 'driver_status_changed',
        parameters: {'is_online': isOnline ? 1 : 0},
      );
    } catch (e) {
      _logger.w('Analytics logDriverOnline failed: $e');
    }
  }

  Future<void> logMissionAccepted(String missionId) async {
    try {
      await _analytics.logEvent(
        name: 'mission_accepted',
        parameters: {'mission_id': missionId},
      );
    } catch (e) {
      _logger.w('Analytics logMissionAccepted failed: $e');
    }
  }

  Future<void> logDeliveryCompleted(String missionId) async {
    try {
      await _analytics.logEvent(
        name: 'delivery_completed',
        parameters: {'mission_id': missionId},
      );
    } catch (e) {
      _logger.w('Analytics logDeliveryCompleted failed: $e');
    }
  }

  // ─── User properties ──────────────────────────────────────────────────────

  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      _logger.w('Analytics setUserId failed: $e');
    }
  }

  Future<void> setUserMode(String mode) async {
    try {
      await _analytics.setUserProperty(name: 'user_mode', value: mode);
    } catch (e) {
      _logger.w('Analytics setUserMode failed: $e');
    }
  }

  Future<void> clearUser() async {
    try {
      await _analytics.setUserId(id: null);
    } catch (e) {
      _logger.w('Analytics clearUser failed: $e');
    }
  }
}

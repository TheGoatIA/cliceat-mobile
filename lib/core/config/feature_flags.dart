class FeatureFlags {
  static const String wallet = 'wallet';
  static const String loyalty = 'loyalty';
  static const String coupons = 'coupons';
  static const String reviews = 'reviews';
  static const String socialAuth = 'social_auth';
  static const String wavePayment = 'wave_payment';
  static const String scheduledOrders = 'scheduled_orders';
  static const String groupOrders = 'group_orders';
  static const String subscription = 'subscription';
  static const String referral = 'referral';
  static const String liveTracking = 'live_tracking';
  static const String restaurantChat = 'restaurant_chat';

  // Helper to check if a feature is enabled
  static bool isEnabled(List<String> activeFeatures, String featureKey) {
    return activeFeatures.contains(featureKey);
  }
}

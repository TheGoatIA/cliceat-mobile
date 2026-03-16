/// Application-wide constants — coordinates, fees, defaults.
/// Update these values to adapt to new cities or business rules.
class AppConstants {
  AppConstants._();

  // ── Default city / map center (Douala, Cameroun) ─────────────────────────
  static const String defaultCity = 'Douala';
  static const double defaultLat = 4.0511;
  static const double defaultLng = 9.7679;
  static const double defaultZoom = 12.0;

  // ── Delivery fee (FCFA) — used as fallback before server value ────────────
  static const double defaultDeliveryFee = 1000.0;

  // ── Location update interval for delivery drivers ─────────────────────────
  static const Duration locationUpdateInterval = Duration(seconds: 5);
}

/// Application-wide constants — coordinates, fees, defaults.
/// Update these values to adapt to new cities or business rules.
class AppConstants {
  AppConstants._();

  // ── Default city / map center (Yaoundé, Cameroun) ─────────────────────────
  static const String defaultCity = 'Yaound\u00e9';
  static const double defaultLat = 3.8480;
  static const double defaultLng = 11.5021;
  static const double defaultZoom = 12.0;

  // ── Delivery fee (FCFA) — used as fallback before server value ────────────
  static const double defaultDeliveryFee = 2000.0;

  // ── Location update interval for delivery drivers ─────────────────────────
  static const Duration locationUpdateInterval = Duration(seconds: 5);

  // ── Image cache limits ────────────────────────────────────────────────────
  // Limite le cache mémoire des images réseau pour éviter les OOM.
  // Flutter utilise PaintingBinding.instance.imageCache par défaut (1000 objets
  // / illimité en taille). On borne explicitement pour les appareils bas de
  // gamme répandus en Afrique subsaharienne.
  static const int imageCacheMaxCount = 150; // nb d'images en mémoire
  static const int imageCacheMaxSizeBytes = 80 * 1024 * 1024; // 80 MiB

  // ── Current app version loaded at startup ─────────────────────────────────
  static String appVersion = '1.0.0';

  // ── Phone placeholder for Cameroon ────────────────────────────────────────
  static const String phoneHintCameroon = '+237 6XX XXX XXX';
}

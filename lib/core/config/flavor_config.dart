/// Identifiant du flavor courant.
enum Flavor { dev, staging, prod }

/// Configuration injectée au démarrage de l'application selon le flavor.
///
/// Utilisation :
/// ```dart
/// FlavorConfig.apiBaseUrl   // URL de l'API
/// FlavorConfig.flavor       // Flavor.dev | Flavor.staging | Flavor.prod
/// FlavorConfig.isDev        // true uniquement en dev
/// ```
class FlavorConfig {
  FlavorConfig._();

  static late Flavor _flavor;
  static late String _apiBaseUrl;
  static late String _wsUrl;
  static late String _mapboxToken;

  static void initialize({
    required Flavor flavor,
    required String apiBaseUrl,
    required String wsUrl,
    required String mapboxToken,
  }) {
    _flavor = flavor;
    _apiBaseUrl = apiBaseUrl;
    _wsUrl = wsUrl;
    _mapboxToken = mapboxToken;
  }

  static Flavor get flavor => _flavor;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get wsUrl => _wsUrl;
  static String get mapboxToken => _mapboxToken;

  static bool get isDev => _flavor == Flavor.dev;
  static bool get isStaging => _flavor == Flavor.staging;
  static bool get isProd => _flavor == Flavor.prod;

  /// Nom humain du flavor (pour les logs et l'UI de debug).
  static String get name => switch (_flavor) {
        Flavor.dev => 'DEV',
        Flavor.staging => 'STAGING',
        Flavor.prod => 'PROD',
      };
}

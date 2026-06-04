/// Gestion de la configuration environnementale en compile-time (--dart-define)
class EnvConfig {
  static const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  
  // Remplacé par FlavorConfig.apiBaseUrl là où c'est utilisé
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  
  static const String mapboxAccessToken = String.fromEnvironment('MAPBOX_ACCESS_TOKEN', defaultValue: '');
  
  // Remplacé par FlavorConfig.wsUrl là où c'est utilisé
  static const String wsUrl = String.fromEnvironment('WS_URL', defaultValue: '');
  
  static const String sslFingerprint = String.fromEnvironment('SSL_FINGERPRINT', defaultValue: '');

  static bool get isDev => appEnv == 'dev';
  static bool get isStaging => appEnv == 'staging';
  static bool get isProd => appEnv == 'prod';
}

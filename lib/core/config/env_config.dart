import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'dev';
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5000/api/v1';
  static String get mapboxAccessToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  static String get wsUrl => dotenv.env['WS_URL'] ?? 'ws://10.0.2.2:5000';

  static bool get isDev => appEnv == 'dev';
  static bool get isStaging => appEnv == 'staging';
  static bool get isProd => appEnv == 'prod';
}

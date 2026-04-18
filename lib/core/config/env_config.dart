import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'dev';
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:5000/api/v1';
  static String get mapboxAccessToken =>
      dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  static String get notchpayPublicKey =>
      dotenv.env['NOTCHPAY_PUBLIC_KEY'] ?? '';

  static String get socketBaseUrl {
    final api = apiBaseUrl;
    final uri = Uri.tryParse(api);
    if (uri == null) return 'http://localhost:5000';
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }

  static bool get isDev => appEnv == 'dev';
  static bool get isStaging => appEnv == 'staging';
  static bool get isProd => appEnv == 'prod';
}

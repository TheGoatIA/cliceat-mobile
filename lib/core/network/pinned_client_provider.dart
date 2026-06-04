import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import '../config/env_config.dart';

/// Provides a pinned [http.Client] that verifies the server certificate fingerprint.
class PinnedHttpClientProvider {
  static Future<http.Client> getClient() async {
    // In Dev, skip pinning to allow self-signed certificates on local servers
    if (EnvConfig.isDev) {
      return http.Client();
    }
    // In Staging/Prod: require a fingerprint — fail loudly if missing
    if (EnvConfig.sslFingerprint.isEmpty) {
      throw StateError(
        'SSL_FINGERPRINT must be set via --dart-define=SSL_FINGERPRINT=... '
        'for Staging and Production builds.',
      );
    }

    // Build the secure HTTP client using the SHA-256 fingerprint(s)
    // SecureHttpClient from http_certificate_pinning implements http.Client
    final client = SecureHttpClient.build([EnvConfig.sslFingerprint]);
    
    return client;
  }
}

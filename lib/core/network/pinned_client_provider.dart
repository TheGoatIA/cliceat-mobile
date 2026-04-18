import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import '../config/env_config.dart';

/// Provides a pinned [http.Client] that verifies the server certificate fingerprint.
class PinnedHttpClientProvider {
  static Future<http.Client> getClient() async {
    // In Dev or if no fingerprint is provided, fallback to standard client
    if (EnvConfig.isDev || EnvConfig.sslFingerprint.isEmpty) {
      return http.Client();
    }

    // Build the secure HTTP client using the SHA-256 fingerprint(s)
    // SecureHttpClient from http_certificate_pinning implements http.Client
    final client = SecureHttpClient.build([EnvConfig.sslFingerprint]);
    
    return client;
  }
}

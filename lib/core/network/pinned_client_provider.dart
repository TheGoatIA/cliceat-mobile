import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:crypto/crypto.dart';
import '../config/env_config.dart';

/// Provides a pinned [http.Client] that verifies the server certificate fingerprint.
/// 
/// Note: This is an extra layer of security for Production.
/// In Dev, it defaults to a standard client if no fingerprint is provided.
class PinnedHttpClientProvider {
  static http.Client getClient() {
    final fingerprint = EnvConfig.sslFingerprint.replaceAll(':', '').toLowerCase();

    if (fingerprint.isEmpty || EnvConfig.isDev) {
      return http.Client();
    }

    final HttpClient httpClient = HttpClient();
    
    // Configure pinning
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Get the SHA-256 hash of the DER-encoded certificate
      final digest = sha256.convert(cert.der);
      final hash = digest.toString().replaceAll(':', '').toLowerCase();
      
      // Valider que l'empreinte calculée correspond à celle en configuration finale
      return hash == fingerprint;
    };

    return IOClient(httpClient);
  }
}

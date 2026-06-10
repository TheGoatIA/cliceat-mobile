import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../di/injection.dart';

/// Un interceptor Chopper qui utilise le package [Logger] pour un affichage propre
/// des requêtes et réponses HTTP dans la console.
///
/// Sécurité : ne logue jamais le body des requêtes/réponses (tokens JWT,
/// mots de passe, etc.). La valeur du header Authorization est masquée.
class LoggingInterceptor implements Interceptor {
  Logger get _logger => getIt<Logger>();

  /// Retourne une copie des headers sans données sensibles.
  /// Si Authorization est présent, sa valeur est remplacée par "[REDACTED]".
  Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: entry.key.toLowerCase() == 'authorization'
            ? 'Bearer [REDACTED]'
            : entry.value,
    };
  }

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    final startTime = DateTime.now();

    _logger.i(
      '🌐 HTTP Request: [${request.method}] ${request.url}\n'
      'Headers: ${_sanitizeHeaders(request.headers)}',
    );

    try {
      final response = await chain.proceed(request);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.isSuccessful) {
        _logger.d(
          '✅ HTTP Response (${response.statusCode}) [${duration}ms]: ${request.url}',
        );
      } else {
        _logger.e(
          '❌ HTTP Error (${response.statusCode}) [${duration}ms]: ${request.url}\n'
          'Error: ${response.error}',
        );
      }

      return response;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      _logger.f(
        '💥 HTTP Failure [${duration}ms]: ${request.url}\n'
        'Exception: $e',
      );
      rethrow;
    }
  }
}

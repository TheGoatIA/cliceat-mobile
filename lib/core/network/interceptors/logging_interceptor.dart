import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';
import '../../di/injection.dart';

/// Un interceptor Chopper qui utilise le package [Logger] pour un affichage propre
/// des requêtes et réponses HTTP dans la console.
class LoggingInterceptor implements Interceptor {
  Logger get _logger => getIt<Logger>();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;
    final startTime = DateTime.now();

    _logger.i('🌐 HTTP Request: [${request.method}] ${request.url}\n'
        'Headers: ${request.headers}\n'
        'Body: ${request.body}');

    try {
      final response = await chain.proceed(request);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.isSuccessful) {
        _logger.d('✅ HTTP Response (${response.statusCode}) [${duration}ms]: ${request.url}\n'
            'Body: ${response.body}');
      } else {
        _logger.e('❌ HTTP Error (${response.statusCode}) [${duration}ms]: ${request.url}\n'
            'Error: ${response.error}\n'
            'Body: ${response.body}');
      }

      return response;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      _logger.f('💥 HTTP Failure [${duration}ms]: ${request.url}\n'
          'Exception: $e');
      rethrow;
    }
  }
}

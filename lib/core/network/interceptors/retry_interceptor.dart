import 'dart:async';
import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';

/// Intercepteur de retry avec backoff exponentiel pour le réseau camerounais
/// (3G/4G instable). Tente jusqu'à [maxRetries] fois sur erreurs transitoires.
///
/// Délais : 1s → 2s → 4s (backoff exponentiel, max [maxRetries] tentatives).
class RetryInterceptor implements Interceptor {
  final int maxRetries;
  final Logger _logger = Logger();

  RetryInterceptor({this.maxRetries = 3});

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    if (chain.request.multipart) {
      return chain.proceed(chain.request);
    }
    int attempt = 0;
    while (true) {
      try {
        final response = await chain.proceed(chain.request);
        // Retry on 5xx server errors (service temporarily unavailable)
        if (response.statusCode >= 500 && attempt < maxRetries) {
          attempt++;
          final delay = Duration(seconds: 1 << (attempt - 1)); // 1s, 2s, 4s
          _logger.w(
            '[Retry] ${chain.request.method} ${chain.request.url} → '
            '${response.statusCode}. Tentative $attempt/$maxRetries dans ${delay.inSeconds}s',
          );
          await Future.delayed(delay);
          continue;
        }
        return response;
      } on SocketException catch (e) {
        if (attempt >= maxRetries) rethrow;
        attempt++;
        final delay = Duration(seconds: 1 << (attempt - 1));
        _logger.w(
          '[Retry] SocketException sur ${chain.request.url}: $e. '
          'Tentative $attempt/$maxRetries dans ${delay.inSeconds}s',
        );
        await Future.delayed(delay);
      } on TimeoutException catch (e) {
        if (attempt >= maxRetries) rethrow;
        attempt++;
        final delay = Duration(seconds: 1 << (attempt - 1));
        _logger.w(
          '[Retry] TimeoutException sur ${chain.request.url}: $e. '
          'Tentative $attempt/$maxRetries dans ${delay.inSeconds}s',
        );
        await Future.delayed(delay);
      }
    }
  }
}

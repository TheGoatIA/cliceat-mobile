import 'dart:async';
import 'package:chopper/chopper.dart';

/// Applique un timeout sur les requêtes HTTP sortantes.
///
/// Optimisé pour le réseau camerounais : receiveTimeout par défaut à 30s.
class TimeoutInterceptor implements Interceptor {
  final Duration receiveTimeout;

  const TimeoutInterceptor({
    this.receiveTimeout = const Duration(seconds: 30),
  });

  @override
  Future<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final future = chain.proceed(chain.request);
    return (future as Future<Response<BodyType>>).timeout(
      receiveTimeout,
      onTimeout: () => throw TimeoutException(
        'Request timed out after ${receiveTimeout.inSeconds}s '
        '(${chain.request.method} ${chain.request.url})',
        receiveTimeout,
      ),
    );
  }
}

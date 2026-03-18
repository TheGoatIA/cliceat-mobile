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
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) {
    return chain.proceed(chain.request).timeout(
      receiveTimeout,
      onTimeout: () => throw TimeoutException(
        'La requête a dépassé le délai de ${receiveTimeout.inSeconds}s '
        '(${chain.request.method} ${chain.request.url})',
        receiveTimeout,
      ),
    );
  }
}

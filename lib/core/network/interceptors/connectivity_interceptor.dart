import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Custom exception thrown when there is no network connectivity.
class NetworkException implements Exception {
  final String messageKey;
  const NetworkException([this.messageKey = 'common.network_error']);

  @override
  String toString() => 'NetworkException($messageKey)';
}

class ConnectivityInterceptor implements Interceptor {
  List<ConnectivityResult>? _cachedResult;
  DateTime? _lastCheck;
  static const _cacheDuration = Duration(seconds: 3);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final now = DateTime.now();
    if (_cachedResult == null ||
        _lastCheck == null ||
        now.difference(_lastCheck!) > _cacheDuration) {
      _cachedResult = await Connectivity().checkConnectivity();
      _lastCheck = now;
    }
    if (_cachedResult!.contains(ConnectivityResult.none)) {
      throw const NetworkException('common.network_error');
    }
    return chain.proceed(chain.request);
  }
}

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

class _ConnectivityState {
  List<ConnectivityResult>? cachedResult;
  DateTime? lastCheck;
}

class ConnectivityInterceptor implements Interceptor {
  final _state = _ConnectivityState();
  static const _cacheDuration = Duration(seconds: 3);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final now = DateTime.now();
    if (_state.cachedResult == null ||
        _state.lastCheck == null ||
        now.difference(_state.lastCheck!) > _cacheDuration) {
      _state.cachedResult = await Connectivity().checkConnectivity();
      _state.lastCheck = now;
    }
    if (_state.cachedResult!.contains(ConnectivityResult.none)) {
      throw const NetworkException('common.network_error');
    }
    return chain.proceed(chain.request);
  }
}

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityInterceptor implements Interceptor {
  List<ConnectivityResult>? _cachedResult;
  DateTime? _lastCheck;
  static const _cacheDuration = Duration(seconds: 3);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final now = DateTime.now();
    if (_cachedResult == null ||
        _lastCheck == null ||
        now.difference(_lastCheck!) > _cacheDuration) {
      _cachedResult = await Connectivity().checkConnectivity();
      _lastCheck = now;
    }
    if (_cachedResult!.contains(ConnectivityResult.none)) {
      throw Exception('common.network_error');
    }
    return chain.proceed(chain.request);
  }
}

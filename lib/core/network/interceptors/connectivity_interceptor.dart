import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetException implements Exception {
  final String message;
  NoInternetException({this.message = 'No internet connection available'});

  @override
  String toString() => message;
}

class ConnectivityInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw NoInternetException();
    }
    return chain.proceed(chain.request);
  }
}

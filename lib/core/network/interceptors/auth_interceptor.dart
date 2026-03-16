import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor implements Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token != null && token.isNotEmpty) {
      final newRequest = request.copyWith(headers: {
        ...request.headers,
        'Authorization': 'Bearer $token',
      });
      return chain.proceed(newRequest);
    }
    return chain.proceed(request);
  }
}

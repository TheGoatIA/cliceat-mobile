import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Intercepts 401 responses, refreshes the JWT token, and retries the request.
/// Accepts a refresh callback to avoid circular import with AuthService.
class RefreshInterceptor implements Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Future<Response> Function() _refreshCallback;

  RefreshInterceptor(this._secureStorage, this._refreshCallback);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);

    if (response.statusCode == 401) {
      try {
        final refreshRes = await _refreshCallback();
        if (refreshRes.isSuccessful && refreshRes.body != null) {
          final body = refreshRes.body as Map<String, dynamic>?;
          final tokens = body?['tokens'] as Map<String, dynamic>?;
          final newToken = tokens?['accessToken'] as String?;

          if (newToken != null) {
            await _secureStorage.write(key: 'jwt_token', value: newToken);
            final retryRequest = chain.request.copyWith(headers: {
              ...chain.request.headers,
              'Authorization': 'Bearer $newToken',
            });
            return chain.proceed(retryRequest);
          }
        }
      } catch (_) {
        // Refresh failed — clear credentials so the app redirects to login
        await _secureStorage.delete(key: 'jwt_token');
        await _secureStorage.delete(key: 'user_id');
      }
    }
    return response;
  }
}

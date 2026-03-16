import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../features/auth/data/datasources/auth_service.dart';

class RefreshInterceptor implements Interceptor {
  final FlutterSecureStorage _secureStorage;
  final AuthService Function() _getAuthService;
  static bool _isRefreshing = false;

  RefreshInterceptor(this._secureStorage, this._getAuthService);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);

    if (response.statusCode == 401 && !_isRefreshing) {
      if (chain.request.url.path.contains('/auth/login') ||
          chain.request.url.path.contains('/auth/refresh')) {
        return response; // Do not intercept login or refresh failures here
      }

      _isRefreshing = true;
      try {
        final authService = _getAuthService();
        final refreshResponse = await authService.refreshToken();

        if (refreshResponse.isSuccessful) {
          final body = refreshResponse.body as Map<String, dynamic>?;
          if (body != null && body['token'] != null) {
            final newToken = body['token'] as String;
            await _secureStorage.write(key: 'jwt_token', value: newToken);

            // Retry the original request with the new token
            final newRequest = chain.request.copyWith(headers: {
              ...chain.request.headers,
              'Authorization': 'Bearer $newToken',
            });
            _isRefreshing = false;
            return chain.proceed(newRequest);
          }
        }
      } catch (e) {
        // Refresh failed, user needs to relogin
      } finally {
        _isRefreshing = false;
      }

      // If refresh failed, we might want to trigger a global logout event here
      // For now, clear token to force login on next auth check
      await _secureStorage.delete(key: 'jwt_token');
    }

    return response;
  }
}

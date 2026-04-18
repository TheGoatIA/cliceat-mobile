import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// Catches 401 responses, attempts a silent token refresh, then retries.
/// On refresh failure, clears storage (forces re-login).
class RefreshInterceptor implements Interceptor {
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;

  RefreshInterceptor(this._storage);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);

    if (response.statusCode != 401) return response;
    if (_isRefreshing) return response;

    final path = chain.request.url.toString();
    if (path.contains('/auth/refresh') || path.contains('/auth/login')) {
      return response;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return response;

      final resp = await http
          .post(
            Uri.parse('${EnvConfig.apiBaseUrl}/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final tokens = data['tokens'] as Map<String, dynamic>?;
        final newAccess = tokens?['accessToken'] as String?;
        final newRefresh = tokens?['refreshToken'] as String?;

        if (newAccess != null) {
          await _storage.write(key: 'jwt_token', value: newAccess);
          if (newRefresh != null) {
            await _storage.write(key: 'refresh_token', value: newRefresh);
          }
          final retried = chain.request.copyWith(headers: {
            ...chain.request.headers,
            'Authorization': 'Bearer $newAccess',
          });
          return chain.proceed(retried);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[RefreshInterceptor] Error: $e');
    } finally {
      _isRefreshing = false;
    }

    // Refresh failed — clear session
    await _storage.deleteAll();
    return response;
  }
}

/// Adds a 30-second timeout to every request.
class TimeoutInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) {
    return chain.proceed(chain.request).timeout(
      const Duration(seconds: 30),
    );
  }
}

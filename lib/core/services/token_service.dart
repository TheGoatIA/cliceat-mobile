import 'dart:async';
import 'dart:convert';
import 'package:cliceat_app/features/auth/data/datasources/auth_service.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class TokenService {
  final FlutterSecureStorage _secureStorage;
  final Logger _logger;

  final _sessionExpiredController = StreamController<void>.broadcast();
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;
  Completer<String?>? _pendingRefresh;

  TokenService(this._secureStorage, this._logger);

  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return null;

    if (isTokenExpired(token)) {
      _logger.i(
        '[TokenService] Token expiré, tentative de rafraîchissement...',
      );
      return refreshToken();
    }

    return token;
  }

  Future<String?> getUserId() async {
    return _secureStorage.read(key: 'user_id');
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      final decoded = utf8.decode(
        base64Decode(
          payload.padRight(payload.length + (4 - payload.length % 4) % 4, '='),
        ),
      );
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = map['exp'] as int?;
      if (exp == null) return false;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      // Prise de marge de 1 minute
      return DateTime.now().isAfter(
        expiry.subtract(const Duration(minutes: 1)),
      );
    } catch (_) {
      // JWT parse failure — treat token as expired (safest default)
      return true;
    }
  }

  Future<String?> refreshToken() async {
    if (_pendingRefresh != null) {
      return _pendingRefresh!.future;
    }

    _pendingRefresh = Completer<String?>();
    try {
      final authService = getIt<AuthService>();
      final res = await authService.refreshToken().timeout(
        const Duration(seconds: 15),
      );

      if (res.isSuccessful && res.body != null) {
        final body = res.body as Map<String, dynamic>?;
        final tokens = body?['tokens'] as Map<String, dynamic>?;
        final newToken = tokens?['accessToken'] as String?;

        if (newToken != null && newToken.isNotEmpty) {
          await _secureStorage.write(key: 'jwt_token', value: newToken);
          _pendingRefresh!.complete(newToken);
          return newToken;
        }
      }

      _logger.w(
        '[TokenService] Refresh non fructueux — signal de session expirée.',
      );
      _sessionExpiredController.add(null);
      _pendingRefresh!.complete(null);
      return null;
    } catch (e) {
      _logger.e('[TokenService] Échec du rafraîchissement: $e');
      _sessionExpiredController.add(null);
      _pendingRefresh!.complete(null);
      return null;
    } finally {
      _pendingRefresh = null;
    }
  }

  void dispose() {
    _sessionExpiredController.close();
  }
}

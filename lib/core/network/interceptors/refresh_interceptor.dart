import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

/// Intercepte les réponses 401, rafraîchit le JWT et rejoue la requête.
///
/// ── Mutex via Completer ────────────────────────────────────────────────────
/// Si plusieurs requêtes reçoivent un 401 simultanément (ex. : app au premier
/// plan après veille), un seul appel de refresh est émis. Les autres attendent
/// la résolution du [Completer] partagé avant de retenter.
///
/// ── Séquence ──────────────────────────────────────────────────────────────
/// 1. Requête → 401
/// 2. Premier thread : crée le Completer, appelle _refreshCallback
/// 3. Autres threads : attendent `_pendingRefresh!.future`
/// 4. Si refresh OK → nouveau token → on retente
/// 5. Si refresh KO → on efface les credentials → l'app redirige vers login
class _RefreshState {
  Completer<String?>? pendingRefresh;
}

class RefreshInterceptor implements Interceptor {
  RefreshInterceptor(this._secureStorage, this._refreshCallback);

  final FlutterSecureStorage _secureStorage;
  final Future<Response> Function() _refreshCallback;
  final Logger _logger = Logger();

  /// État mutable encapsulé pour respecter l'immutabilité de l'intercepteur.
  final _state = _RefreshState();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);

    if (response.statusCode != 401) return response;

    // ── Attendre le refresh en cours ou en démarrer un ────────────────────

    final newToken = await _getOrStartRefresh();

    if (newToken == null) {
      // Refresh échoué → l'AuthBloc recevra un sessionExpired via le storage
      _logger.w('[RefreshInterceptor] Refresh échoué — session expirée.');
      return response;
    }

    // ── Retenter la requête originale avec le nouveau token ────────────────

    _logger.d('[RefreshInterceptor] Token rafraîchi — rejeu de la requête.');
    final retried = chain.request.copyWith(headers: {
      ...chain.request.headers,
      'Authorization': 'Bearer $newToken',
    });
    return chain.proceed(retried);
  }

  // ─── Mutex ────────────────────────────────────────────────────────────────

  Future<String?> _getOrStartRefresh() async {
    // Si un refresh est déjà en cours → attendre son résultat
    if (_state.pendingRefresh != null) {
      _logger.d('[RefreshInterceptor] Refresh déjà en cours — en attente...');
      return _state.pendingRefresh!.future;
    }

    // Premier appelant → démarrer le refresh
    _state.pendingRefresh = Completer<String?>();

    try {
      final newToken = await _doRefresh();
      _state.pendingRefresh!.complete(newToken);
      return newToken;
    } catch (e, stack) {
      _logger.e('[RefreshInterceptor] Erreur lors du refresh', error: e, stackTrace: stack);
      _state.pendingRefresh!.complete(null);
      return null;
    } finally {
      // Libérer le mutex après un court délai pour que les waiters puissent lire
      await Future<void>.delayed(const Duration(milliseconds: 50));
      _state.pendingRefresh = null;
    }
  }

  Future<String?> _doRefresh() async {
    try {
      final refreshRes = await _refreshCallback();

      if (refreshRes.isSuccessful && refreshRes.body != null) {
        final body = refreshRes.body as Map<String, dynamic>?;
        final tokens = body?['tokens'] as Map<String, dynamic>?;
        final newToken = tokens?['accessToken'] as String?;

        if (newToken != null && newToken.isNotEmpty) {
          await _secureStorage.write(key: 'jwt_token', value: newToken);
          _logger.i('[RefreshInterceptor] Nouveau token stocké.');
          return newToken;
        }
      }

      // Refresh non fructueux → nettoyer les credentials
      await _clearCredentials();
      return null;
    } catch (_) {
      await _clearCredentials();
      rethrow;
    }
  }

  Future<void> _clearCredentials() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'user_id');
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../data/local/database.dart';
import '../repositories/order_repository.dart';

/// Service de synchronisation hors-ligne.
///
/// Enregistre les actions qui échouent faute de réseau dans la table
/// [PendingActionsTable] et les rejoue automatiquement au retour en ligne.
///
/// Usage :
/// ```dart
/// final sync = OfflineSyncService(db, orderRepository);
/// await sync.initialize(); // démarre l'écoute connectivité
/// await sync.enqueue('create_order', {'restaurantId': '...', 'items': [...]});
/// ```
class OfflineSyncService {
  OfflineSyncService(this._db, this._orderRepository);

  final AppDatabase _db;
  final OrderRepository _orderRepository;
  final Logger _logger = Logger();
  final _uuid = const Uuid();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  static const _maxRetries = 3;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  /// Démarre l'écoute des changements de connectivité.
  /// Appeler une seule fois depuis le point d'entrée de l'app ou via DI.
  Future<void> initialize() async {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChanged);

    // Rejouer immédiatement si déjà en ligne
    final results = await Connectivity().checkConnectivity();
    _onConnectivityChanged(results);
  }

  void dispose() {
    _connectivitySub?.cancel();
  }

  // ─── Queue ────────────────────────────────────────────────────────────────

  /// Enfile une action à synchroniser plus tard.
  Future<void> enqueue(
    String type,
    Map<String, dynamic> payload,
  ) async {
    await _db.into(_db.pendingActionsTable).insert(
          PendingActionsTableCompanion.insert(
            id: _uuid.v4(),
            type: type,
            payload: jsonEncode(payload),
          ),
        );
    _logger.d('[OfflineSync] Action enfilée: type=$type');
  }

  // ─── Replay ───────────────────────────────────────────────────────────────

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (isOnline) {
      _replayPendingActions();
    }
  }

  Future<void> _replayPendingActions() async {
    final pending = await (_db.select(_db.pendingActionsTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();

    if (pending.isEmpty) return;

    _logger.i('[OfflineSync] ${pending.length} action(s) en attente — rejeu...');

    for (final action in pending) {
      await _processAction(action);
    }
  }

  Future<void> _processAction(PendingActionsTableData action) async {
    if (action.retryCount >= _maxRetries) {
      _logger.w(
        '[OfflineSync] Action ${action.id} (${action.type}) abandonnée '
        'après $_maxRetries tentatives.',
      );
      await _delete(action.id);
      return;
    }

    try {
      final payload =
          jsonDecode(action.payload) as Map<String, dynamic>;
      final success = await _dispatch(action.type, payload);

      if (success) {
        _logger.i('[OfflineSync] Action ${action.id} (${action.type}) rejouée avec succès.');
        await _delete(action.id);
      } else {
        await _incrementRetry(action);
      }
    } catch (e, stack) {
      _logger.e('[OfflineSync] Erreur lors du rejeu de ${action.id}', error: e, stackTrace: stack);
      await _incrementRetry(action);
    }
  }

  /// Dispatche l'action vers le bon repository.
  Future<bool> _dispatch(
      String type, Map<String, dynamic> payload) async {
    switch (type) {
      case 'create_order':
        final result = await _orderRepository.createOrder(payload);
        return result.isRight();

      case 'cancel_order':
        final orderId = payload['orderId'] as String?;
        if (orderId == null) return false;
        final result = await _orderRepository.cancelOrder(orderId);
        return result.isRight();

      case 'rate_order':
        final orderId = payload['orderId'] as String?;
        final rating = payload['rating'] as int?;
        if (orderId == null || rating == null) return false;
        final comment = payload['comment'] as String?;
        final result =
            await _orderRepository.rateOrder(orderId, rating, comment);
        return result.isRight();

      default:
        _logger.w('[OfflineSync] Type d\'action inconnu: $type');
        return false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _delete(String id) async {
    await (_db.delete(_db.pendingActionsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> _incrementRetry(PendingActionsTableData action) async {
    await (_db.update(_db.pendingActionsTable)
          ..where((t) => t.id.equals(action.id)))
        .write(PendingActionsTableCompanion(
          retryCount: Value(action.retryCount + 1),
        ));
  }
}

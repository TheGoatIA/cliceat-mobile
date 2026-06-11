import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database.dart';
import '../tables/offline_actions_table.dart';

part 'offline_queue_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [OfflineActionsTable])
class OfflineQueueDao extends DatabaseAccessor<AppDatabase>
    with _$OfflineQueueDaoMixin {
  OfflineQueueDao(super.db);

  /// Retourne toutes les actions en attente dont le nombre de tentatives
  /// n'a pas encore atteint le maximum.
  Future<List<OfflineActionsTableData>> getPendingActions() =>
      (select(offlineActionsTable)
            ..where(
              (t) =>
                  t.status.equals('pending') &
                  t.retryCount.isSmallerThan(t.maxRetries),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  /// Insère une nouvelle action dans la table.
  Future<int> insertAction(OfflineActionsTableCompanion action) =>
      into(offlineActionsTable).insert(action);

  /// Marque une action comme échouée (dépassement de retries).
  Future<void> markFailed(int id) =>
      (update(offlineActionsTable)..where((t) => t.id.equals(id))).write(
        const OfflineActionsTableCompanion(status: Value('failed')),
      );

  /// Incrémente le compteur de tentatives d'une action.
  Future<void> incrementRetry(int id) async {
    final action = await (select(offlineActionsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (action == null) return;
    await (update(offlineActionsTable)..where((t) => t.id.equals(id))).write(
      OfflineActionsTableCompanion(
        retryCount: Value(action.retryCount + 1),
      ),
    );
  }

  /// Supprime une action (après traitement réussi).
  Future<void> deleteAction(int id) =>
      (delete(offlineActionsTable)..where((t) => t.id.equals(id))).go();

  /// Supprime toutes les actions marquées 'completed'.
  Future<void> deleteAllCompleted() =>
      (delete(offlineActionsTable)..where((t) => t.status.equals('completed')))
          .go();
}

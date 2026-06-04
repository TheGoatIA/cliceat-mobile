import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/pending_actions_table.dart';
import 'package:injectable/injectable.dart';

part 'pending_actions_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [PendingActionsTable])
class PendingActionsDao extends DatabaseAccessor<AppDatabase> with _$PendingActionsDaoMixin {
  PendingActionsDao(super.db);

  Future<List<PendingActionsTableData>> getAllPending() {
    return (select(pendingActionsTable)..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
  }

  Future<void> addPending(String type, String payload) {
    return into(pendingActionsTable).insert(
      PendingActionsTableCompanion.insert(
        id: uuid.v4(),
        type: type,
        payload: payload,
      ),
    );
  }

  Future<void> incrementRetry(String id) async {
    final act = await (select(pendingActionsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (act != null) {
      await update(pendingActionsTable).replace(
        act.copyWith(retryCount: act.retryCount + 1)
      );
    }
  }

  Future<void> deletePending(String id) {
    return (delete(pendingActionsTable)..where((t) => t.id.equals(id))).go();
  }
}

// simple uuid generator pour nos ids hors-ligne
class Uuid {
  String v4() => '${DateTime.now().millisecondsSinceEpoch}_${identityHashCode(this)}';
}
final uuid = Uuid();

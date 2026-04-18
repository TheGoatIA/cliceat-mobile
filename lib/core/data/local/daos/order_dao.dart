import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/core/data/local/tables/orders_table.dart';

part 'order_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [OrdersTable])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(super.attachedDatabase);

  Future<void> upsertAll(List<OrdersTableCompanion> comps) async {
    await batch((b) {
      b.insertAll(ordersTable, comps, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> upsert(OrdersTableCompanion comp) async {
    await into(ordersTable).insertOnConflictUpdate(comp);
  }

  Future<List<OrdersTableData>> getAll() =>
      (select(ordersTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Future<OrdersTableData?> getById(String id) =>
      (select(ordersTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> deleteOrder(String id) =>
      (delete(ordersTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearAll() => delete(ordersTable).go();
}

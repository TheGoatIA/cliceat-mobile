import 'package:drift/drift.dart';
import '../app_database.dart';

part 'order_dao.g.dart';

@DriftAccessor(tables: [Orders])
class OrderDao extends DatabaseAccessor<AppDatabase>
    with _$OrderDaoMixin {
  OrderDao(super.db);

  Future<List<Order>> getMyOrders() =>
      (select(orders)..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
          .get();

  Future<Order?> getOrderById(String id) =>
      (select(orders)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<void> upsertOrder(OrdersCompanion entry) =>
      into(orders).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<OrdersCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(orders, entries));
}

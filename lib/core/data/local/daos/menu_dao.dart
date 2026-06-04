import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/menu_items_table.dart';
import 'package:injectable/injectable.dart';

part 'menu_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [MenuItemsTable])
class MenuDao extends DatabaseAccessor<AppDatabase> with _$MenuDaoMixin {
  MenuDao(super.db);

  Future<List<MenuItemsTableData>> getByRestaurant(String restaurantId) {
    return (select(
      menuItemsTable,
    )..where((t) => t.restaurantId.equals(restaurantId))).get();
  }

  Future<void> replaceItemsForRestaurant(
    String restaurantId,
    List<MenuItemsTableCompanion> items,
  ) async {
    return transaction(() async {
      await (delete(
        menuItemsTable,
      )..where((t) => t.restaurantId.equals(restaurantId))).go();
      await batch((batch) {
        batch.insertAll(menuItemsTable, items);
      });
    });
  }

  Future<void> clearAll() => delete(menuItemsTable).go();
}

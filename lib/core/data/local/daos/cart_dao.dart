import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';
import '../database.dart';

/// Data Access Object for cart operations.
/// Works directly with the existing [AppDatabase] without code generation.
@lazySingleton
class CartDao {
  final AppDatabase _db;

  CartDao(this._db);

  Future<List<CartTableData>> getAllItems() => _db.select(_db.cartTable).get();

  Stream<List<CartTableData>> watchAllItems() =>
      _db.select(_db.cartTable).watch();

  Future<void> insertItem(CartTableCompanion item) =>
      _db.into(_db.cartTable).insertOnConflictUpdate(item);

  Future<void> updateQuantity(String id, int quantity) =>
      (_db.update(_db.cartTable)..where((t) => t.id.equals(id))).write(
        CartTableCompanion(quantity: drift.Value(quantity)),
      );

  Future<void> deleteItem(String id) =>
      (_db.delete(_db.cartTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearCart() => _db.delete(_db.cartTable).go();

  Future<CartTableData?> getItemByItemIdAndVariation(
    String itemId,
    String? variation,
  ) async {
    final query = _db.select(_db.cartTable)
      ..where((t) => t.itemId.equals(itemId));
    final results = await query.get();
    if (variation != null) {
      return results.where((r) => r.variationJson == variation).firstOrNull;
    }
    return results.where((r) => r.variationJson == null).firstOrNull;
  }
}

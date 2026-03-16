import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../../core/data/local/database.dart';

class CartItem {
  final String id;
  final String restaurantId;
  final String itemId;
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.restaurantId,
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        restaurantId: restaurantId,
        itemId: itemId,
        name: name,
        price: price,
        quantity: quantity ?? this.quantity,
      );
}

class CartState {
  final List<CartItem> items;

  const CartState({required this.items});

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  String? get restaurantId =>
      items.isNotEmpty ? items.first.restaurantId : null;
}

class CartCubit extends Cubit<CartState> {
  final AppDatabase _db;

  CartCubit(this._db) : super(const CartState(items: [])) {
    loadCart();
  }

  Future<void> loadCart() async {
    final rows = await _db.select(_db.cartTable).get();
    final items = rows
        .map((row) => CartItem(
              id: row.id,
              restaurantId: row.restaurantId,
              itemId: row.itemId,
              name: row.name,
              price: row.price,
              quantity: row.quantity,
            ))
        .toList();
    emit(CartState(items: items));
  }

  Future<void> addItem({
    required String restaurantId,
    required String itemId,
    required String name,
    required double price,
  }) async {
    final current = state;

    // If cart has items from a different restaurant, clear first
    if (current.restaurantId != null &&
        current.restaurantId != restaurantId) {
      await clearCart();
    }

    // Check if item already in cart
    final existing = state.items.where((i) => i.itemId == itemId);
    if (existing.isNotEmpty) {
      await updateQuantity(existing.first.id, existing.first.quantity + 1);
      return;
    }

    final id = '${itemId}_${DateTime.now().millisecondsSinceEpoch}';
    await _db.into(_db.cartTable).insert(CartTableCompanion.insert(
          id: id,
          restaurantId: restaurantId,
          itemId: itemId,
          name: name,
          price: price,
        ));
    await loadCart();
  }

  Future<void> removeItem(String id) async {
    await (_db.delete(_db.cartTable)
          ..where((t) => t.id.equals(id)))
        .go();
    await loadCart();
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity <= 0) {
      await removeItem(id);
      return;
    }
    await (_db.update(_db.cartTable)..where((t) => t.id.equals(id)))
        .write(CartTableCompanion(quantity: drift.Value(quantity)));
    await loadCart();
  }

  Future<void> clearCart() async {
    await _db.delete(_db.cartTable).go();
    emit(const CartState(items: []));
  }
}

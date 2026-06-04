import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/data/local/database.dart';
import '../../../../../core/services/analytics_service.dart';

class CartItem {
  final String id;
  final String restaurantId;
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String? variation;
  final String? notes;

  const CartItem({
    required this.id,
    required this.restaurantId,
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.variation,
    this.notes,
  });

  CartItem copyWith({int? quantity, String? variation, String? notes}) =>
      CartItem(
        id: id,
        restaurantId: restaurantId,
        itemId: itemId,
        name: name,
        price: price,
        quantity: quantity ?? this.quantity,
        variation: variation ?? this.variation,
        notes: notes ?? this.notes,
      );
}

class CartState {
  final List<CartItem> items;

  /// Dynamic delivery fee from the restaurant (defaults to AppConstants).
  final double deliveryFee;

  const CartState({
    required this.items,
    this.deliveryFee = AppConstants.defaultDeliveryFee,
  });

  CartState copyWith({List<CartItem>? items, double? deliveryFee}) => CartState(
    items: items ?? this.items,
    deliveryFee: deliveryFee ?? this.deliveryFee,
  );

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String? get restaurantId =>
      items.isNotEmpty ? items.first.restaurantId : null;

  /// True if adding an item from [newRestaurantId] would clear the current cart.
  bool wouldClearCart(String newRestaurantId) =>
      restaurantId != null && restaurantId != newRestaurantId;
}

@lazySingleton
class CartCubit extends Cubit<CartState> {
  final AppDatabase _db;
  final AnalyticsService _analytics;

  CartCubit(this._db, this._analytics) : super(const CartState(items: [])) {
    loadCart();
  }

  Future<void> loadCart() async {
    final rows = await _db.select(_db.cartTable).get();
    final items = rows
        .map(
          (row) => CartItem(
            id: row.id,
            restaurantId: row.restaurantId,
            itemId: row.itemId,
            name: row.name,
            price: row.price,
            quantity: row.quantity,
            variation: row.variationJson,
            notes: row.notes,
          ),
        )
        .toList();
    emit(state.copyWith(items: items));
    _analytics.logViewCart(state.subtotal);
  }

  /// Adds an item. If [deliveryFee] is provided, updates the cart's delivery fee.
  /// Does NOT auto-clear a conflicting restaurant — callers must call
  /// [clearCart] first (after showing a confirmation dialog) when
  /// [state.wouldClearCart(restaurantId)] is true.
  Future<void> addItem({
    required String restaurantId,
    required String itemId,
    required String name,
    required double price,
    double? deliveryFee,
    String? variation,
    String? notes,
  }) async {
    // Safety: if restaurant differs, clear silently (UI should handle dialog)
    if (state.wouldClearCart(restaurantId)) {
      await clearCart();
    }

    // Increment quantity if item already in cart (same itemId + variation)
    final existing = state.items.where(
      (i) => i.itemId == itemId && i.variation == variation,
    );
    if (existing.isNotEmpty) {
      await updateQuantity(existing.first.id, existing.first.quantity + 1);
      if (deliveryFee != null) {
        emit(state.copyWith(deliveryFee: deliveryFee));
      }
      return;
    }

    final id =
        '${itemId}_${variation ?? ''}_${DateTime.now().millisecondsSinceEpoch}';
    await _db
        .into(_db.cartTable)
        .insert(
          CartTableCompanion.insert(
            id: id,
            restaurantId: restaurantId,
            itemId: itemId,
            name: name,
            price: price,
            variationJson: drift.Value(variation),
            notes: drift.Value(notes),
          ),
        );
    await loadCart();
    if (deliveryFee != null) {
      emit(state.copyWith(deliveryFee: deliveryFee));
    }
    _analytics.logAddToCart(
      itemId: itemId,
      itemName: name,
      price: price,
      restaurantId: restaurantId,
    );
  }

  Future<void> removeItem(String id) async {
    await (_db.delete(_db.cartTable)..where((t) => t.id.equals(id))).go();
    await loadCart();
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity <= 0) {
      await removeItem(id);
      return;
    }
    await (_db.update(_db.cartTable)..where((t) => t.id.equals(id))).write(
      CartTableCompanion(quantity: drift.Value(quantity)),
    );
    await loadCart();
  }

  /// Updates the delivery fee without changing cart items.
  void setDeliveryFee(double fee) {
    emit(state.copyWith(deliveryFee: fee));
  }

  Future<void> clearCart() async {
    await _db.delete(_db.cartTable).go();
    emit(const CartState(items: []));
  }
}

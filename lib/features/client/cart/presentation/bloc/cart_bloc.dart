import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';

// Events
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String itemId;
  RemoveFromCart(this.itemId);
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;
  UpdateQuantity(this.itemId, this.quantity);
}

class ClearCart extends CartEvent {}

class ApplyCoupon extends CartEvent {
  final String code;
  final double discount;
  ApplyCoupon(this.code, this.discount);
}

class RemoveCoupon extends CartEvent {}

// State
class CartState {
  final List<CartItem> items;
  final String? couponCode;
  final double couponDiscount;

  const CartState({
    this.items = const [],
    this.couponCode,
    this.couponDiscount = 0,
  });

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.total);

  double get deliveryFee => items.isEmpty ? 0 : 500;

  double get total => subtotal + deliveryFee - couponDiscount;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  String? get restaurantId => items.isEmpty ? null : items.first.restaurantId;

  CartState copyWith({
    List<CartItem>? items,
    String? couponCode,
    double? couponDiscount,
  }) =>
      CartState(
        items: items ?? this.items,
        couponCode: couponCode ?? this.couponCode,
        couponDiscount: couponDiscount ?? this.couponDiscount,
      );
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAdd);
    on<RemoveFromCart>(_onRemove);
    on<UpdateQuantity>(_onUpdate);
    on<ClearCart>(_onClear);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
  }

  void _onAdd(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.itemId == event.item.itemId);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    } else {
      // Enforce single restaurant rule
      if (items.isNotEmpty &&
          items.first.restaurantId != event.item.restaurantId) {
        items.clear();
      }
      items.add(event.item);
    }
    emit(state.copyWith(items: items));
  }

  void _onRemove(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((i) => i.itemId != event.itemId)
        .toList();
    emit(state.copyWith(
      items: items,
      couponDiscount: items.isEmpty ? 0 : null,
      couponCode: items.isEmpty ? null : null,
    ));
  }

  void _onUpdate(UpdateQuantity event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    if (event.quantity <= 0) {
      items.removeWhere((i) => i.itemId == event.itemId);
    } else {
      final idx = items.indexWhere((i) => i.itemId == event.itemId);
      if (idx >= 0) {
        items[idx] = items[idx].copyWith(quantity: event.quantity);
      }
    }
    emit(state.copyWith(items: items));
  }

  void _onClear(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  void _onApplyCoupon(ApplyCoupon event, Emitter<CartState> emit) {
    emit(CartState(
      items: state.items,
      couponCode: event.code,
      couponDiscount: event.discount,
    ));
  }

  void _onRemoveCoupon(RemoveCoupon event, Emitter<CartState> emit) {
    emit(CartState(items: state.items));
  }
}

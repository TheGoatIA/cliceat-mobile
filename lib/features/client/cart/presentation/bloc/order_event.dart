part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.createOrder(Map<String, dynamic> payload) = _CreateOrder;
  const factory OrderEvent.fetchMyOrders() = _FetchMyOrders;
}

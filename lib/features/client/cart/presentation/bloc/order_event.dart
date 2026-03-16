part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.createOrder(Map<String, dynamic> payload) =
      _CreateOrder;
  const factory OrderEvent.loadOrders() = _LoadOrders;
  const factory OrderEvent.cancelOrder(String orderId) = _CancelOrder;
  const factory OrderEvent.rateOrder(
      {required String orderId,
      required int rating,
      String? comment}) = _RateOrder;
}

part of 'order_bloc.dart';

abstract class OrderEvent {
  const OrderEvent();

  static OrderEvent createOrder(Map<String, dynamic> payload) =>
      CreateOrder(payload);
  static OrderEvent loadOrders() => const LoadOrders();
  static OrderEvent loadMoreOrders() => const LoadMoreOrders();
  static OrderEvent cancelOrder(String orderId, [String? reason]) =>
      CancelOrder(orderId, reason);
  static OrderEvent reorderOrder(String orderId) => ReorderOrder(orderId);
  static OrderEvent rateOrder({
    required String orderId,
    required int restaurantRating,
    required int deliveryRating,
    String? comment,
  }) => RateOrder(
    orderId: orderId,
    restaurantRating: restaurantRating,
    deliveryRating: deliveryRating,
    comment: comment,
  );
  static OrderEvent downloadInvoice(String orderId) => DownloadInvoice(orderId);
  static OrderEvent statusUpdate(Map<String, dynamic> payload) =>
      StatusUpdate(payload);
}

class CreateOrder extends OrderEvent {
  final Map<String, dynamic> payload;
  const CreateOrder(this.payload);
}

class LoadOrders extends OrderEvent {
  const LoadOrders();
}

class LoadMoreOrders extends OrderEvent {
  const LoadMoreOrders();
}

class CancelOrder extends OrderEvent {
  final String orderId;
  final String? reason;
  const CancelOrder(this.orderId, [this.reason]);
}

class ReorderOrder extends OrderEvent {
  final String orderId;
  const ReorderOrder(this.orderId);
}

class RateOrder extends OrderEvent {
  final String orderId;
  final int restaurantRating;
  final int deliveryRating;
  final String? comment;
  const RateOrder({
    required this.orderId,
    required this.restaurantRating,
    required this.deliveryRating,
    this.comment,
  });
}

class DownloadInvoice extends OrderEvent {
  final String orderId;
  const DownloadInvoice(this.orderId);
}

class StatusUpdate extends OrderEvent {
  final Map<String, dynamic> payload;
  const StatusUpdate(this.payload);
}

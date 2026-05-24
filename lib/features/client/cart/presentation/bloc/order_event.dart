part of 'order_bloc.dart';

abstract class OrderEvent {
  const OrderEvent();

  static OrderEvent createOrder(Map<String, dynamic> payload) => CreateOrder(payload);
  static OrderEvent loadOrders() => const LoadOrders();
  static OrderEvent loadMoreOrders() => const LoadMoreOrders();
  static OrderEvent cancelOrder(String orderId, [String? reason]) => CancelOrder(orderId, reason);
  static OrderEvent reorderOrder(String orderId) => ReorderOrder(orderId);
  static OrderEvent rateOrder({required String orderId, required int rating, String? comment}) => 
      RateOrder(orderId: orderId, rating: rating, comment: comment);
  static OrderEvent downloadInvoice(String orderId) => DownloadInvoice(orderId);
  static OrderEvent statusUpdate(Map<String, dynamic> payload) => StatusUpdate(payload);
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
  final int rating;
  final String? comment;
  const RateOrder({required this.orderId, required this.rating, this.comment});
}

class DownloadInvoice extends OrderEvent {
  final String orderId;
  const DownloadInvoice(this.orderId);
}

class StatusUpdate extends OrderEvent {
  final Map<String, dynamic> payload;
  const StatusUpdate(this.payload);
}

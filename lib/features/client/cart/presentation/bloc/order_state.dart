part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
<<<<<<< HEAD
  const factory OrderState.created({
    required String orderId,
    String? paymentUrl,
  }) = _Created;
  const factory OrderState.ordersLoaded(
      List<Map<String, dynamic>> orders) = _OrdersLoaded;
  const factory OrderState.loadingMore(
      List<Map<String, dynamic>> orders) = _LoadingMore;
  const factory OrderState.cancelled() = _Cancelled;
  const factory OrderState.rated() = _Rated;
  const factory OrderState.reorderSuccess(String newOrderId) = _ReorderSuccess;
  const factory OrderState.invoiceDownloaded(String filePath) = _InvoiceDownloaded;
=======
  const factory OrderState.created(String orderId, String? paymentUrl) = _Created;
  const factory OrderState.loaded(List<Map<String, dynamic>> orders) = _Loaded;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
  const factory OrderState.error(String message) = _Error;
}

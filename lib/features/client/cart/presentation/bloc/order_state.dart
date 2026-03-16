part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.created(String orderId, String? paymentUrl) = _Created;
  const factory OrderState.loaded(List<Map<String, dynamic>> orders) = _Loaded;
  const factory OrderState.error(String message) = _Error;
}

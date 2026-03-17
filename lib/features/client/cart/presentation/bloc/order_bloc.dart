import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import '../../../../../core/repositories/order_repository.dart';
import '../../../../../core/services/analytics_service.dart';
import '../../../../../core/di/injection.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final Logger _logger = Logger();

  OrderBloc(this._orderRepository) : super(const OrderState.initial()) {
    on<_CreateOrder>(_onCreateOrder);
    on<_LoadOrders>(_onLoadOrders);
    on<_CancelOrder>(_onCancelOrder);
    on<_RateOrder>(_onRateOrder);
  }

  Future<void> _onCreateOrder(
      _CreateOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    final result = await _orderRepository.createOrder(event.payload);
    result.fold(
      (err) {
        _logger.e('Error creating order: ${err.message}');
        emit(OrderState.error(err.message));
      },
      (order) {
        getIt<AnalyticsService>().logPurchase(
          orderId: order.id,
          total: order.total,
          deliveryFee: order.deliveryFee,
        );
        emit(OrderState.created(
            orderId: order.id, paymentUrl: order.paymentUrl));
      },
    );
  }

  Future<void> _onLoadOrders(
      _LoadOrders event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    final result = await _orderRepository.getOrders();
    result.fold(
      (err) {
        _logger.e('Error loading orders: ${err.message}');
        emit(const OrderState.error('order.error_load'));
      },
      (orders) {
        // Convert to Map for compatibility with existing freezed state type
        final maps = orders.map((o) => o.toJson()).toList();
        emit(OrderState.ordersLoaded(maps));
      },
    );
  }

  Future<void> _onCancelOrder(
      _CancelOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    final result = await _orderRepository.cancelOrder(event.orderId);
    result.fold(
      (err) {
        _logger.e('Error cancelling order: ${err.message}');
        emit(OrderState.error(err.message));
      },
      (_) {
        getIt<AnalyticsService>().logOrderCancelled(event.orderId);
        emit(const OrderState.cancelled());
      },
    );
  }

  Future<void> _onRateOrder(
      _RateOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    final result = await _orderRepository.rateOrder(
        event.orderId, event.rating, event.comment);
    result.fold(
      (err) {
        _logger.e('Error rating order: ${err.message}');
        emit(OrderState.error(err.message));
      },
      (_) => emit(const OrderState.rated()),
    );
  }
}

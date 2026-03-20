import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';
import '../../../../../core/services/analytics_service.dart';
import 'package:cliceat_app/di/injection.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final Logger _logger = Logger();

  // ─── Pagination state ─────────────────────────────────────────────────────

  static const _pageSize = 20;
  int _currentPage = 1;
  bool _hasMore = true;
  final List<Map<String, dynamic>> _accumulated = [];

  OrderBloc(this._orderRepository) : super(const OrderState.initial()) {
    on<_CreateOrder>(_onCreateOrder);
    on<_LoadOrders>(_onLoadOrders);
    on<_LoadMoreOrders>(_onLoadMoreOrders);
    on<_CancelOrder>(_onCancelOrder);
    on<_ReorderOrder>(_onReorderOrder);
    on<_RateOrder>(_onRateOrder);
    on<_DownloadInvoice>(_onDownloadInvoice);
  }

  // ─── Getters for the UI ───────────────────────────────────────────────────

  bool get hasMore => _hasMore;

  // ─── Handlers ─────────────────────────────────────────────────────────────

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
    // Réinitialiser la pagination
    _currentPage = 1;
    _hasMore = true;
    _accumulated.clear();

    emit(const OrderState.loading());
    final result = await _orderRepository.getOrders(
      page: _currentPage,
      limit: _pageSize,
    );
    result.fold(
      (err) {
        _logger.e('Error loading orders: ${err.message}');
        emit(const OrderState.error('order.error_load'));
      },
      (orders) {
        final maps = orders.map((o) => o.toJson()).toList();
        _accumulated.addAll(maps);
        _hasMore = orders.length >= _pageSize;
        _currentPage++;
        emit(OrderState.ordersLoaded(List.unmodifiable(_accumulated)));
      },
    );
  }

  Future<void> _onLoadMoreOrders(
      _LoadMoreOrders event, Emitter<OrderState> emit) async {
    if (!_hasMore) return;

    // Émettre l'état de chargement de page supplémentaire
    emit(OrderState.loadingMore(List.unmodifiable(_accumulated)));

    final result = await _orderRepository.getOrders(
      page: _currentPage,
      limit: _pageSize,
    );
    result.fold(
      (err) {
        _logger.e('Error loading more orders: ${err.message}');
        // En cas d'erreur, on reste sur les données déjà chargées
        emit(OrderState.ordersLoaded(List.unmodifiable(_accumulated)));
      },
      (orders) {
        final maps = orders.map((o) => o.toJson()).toList();
        _accumulated.addAll(maps);
        _hasMore = orders.length >= _pageSize;
        _currentPage++;
        emit(OrderState.ordersLoaded(List.unmodifiable(_accumulated)));
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

  Future<void> _onReorderOrder(
      _ReorderOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    final result = await _orderRepository.reorder(event.orderId);
    result.fold(
      (err) {
        _logger.e('Error reordering: ${err.message}');
        emit(OrderState.error(err.message));
      },
      (order) => emit(OrderState.reorderSuccess(order.id)),
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

  Future<void> _onDownloadInvoice(
      _DownloadInvoice event, Emitter<OrderState> emit) async {
    final result = await _orderRepository.downloadInvoice(event.orderId);
    result.fold(
      (err) {
        _logger.e('Error downloading invoice: ${err.message}');
        emit(OrderState.error(err.message));
      },
      (path) => emit(OrderState.invoiceDownloaded(path)),
    );
    // Restore the list state seamlessly
    if (_accumulated.isNotEmpty) {
      emit(OrderState.ordersLoaded(List.unmodifiable(_accumulated)));
    }
  }
}

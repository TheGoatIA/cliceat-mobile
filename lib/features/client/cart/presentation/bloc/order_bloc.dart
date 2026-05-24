import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:cliceat_app/core/services/websocket_service.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';
import '../../../../../core/services/analytics_service.dart';
import 'package:cliceat_app/core/di/injection.dart';

part 'order_event.dart';
part 'order_bloc.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
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
  const factory OrderState.error(String message) = _Error;
}

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final WebSocketService _wsService;
  final Logger _logger = Logger();
  StreamSubscription? _wsSub;

  // ─── Pagination state ─────────────────────────────────────────────────────

  static const _pageSize = 20;
  int _currentPage = 1;
  bool _hasMore = true;
  final List<Map<String, dynamic>> _accumulated = [];

  OrderBloc(this._orderRepository, this._wsService) : super(const OrderState.initial()) {
    on<CreateOrder>(_onCreateOrder);
    on<LoadOrders>(_onLoadOrders);
    on<LoadMoreOrders>(_onLoadMoreOrders);
    on<CancelOrder>(_onCancelOrder);
    on<ReorderOrder>(_onReorderOrder);
    on<RateOrder>(_onRateOrder);
    on<DownloadInvoice>(_onDownloadInvoice);
    on<StatusUpdate>(_onStatusUpdate);

    // Listen to real-time order status updates
    _wsSub = _wsService.orderTrackingEvents.listen((data) {
      add(OrderEvent.statusUpdate(data));
    });
  }

  @override
  Future<void> close() {
    _wsSub?.cancel();
    return super.close();
  }

  // ─── Getters for the UI ───────────────────────────────────────────────────

  bool get hasMore => _hasMore;

  // ─── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _onCreateOrder(
      CreateOrder event, Emitter<OrderState> emit) async {
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
      LoadOrders event, Emitter<OrderState> emit) async {
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
      LoadMoreOrders event, Emitter<OrderState> emit) async {
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
      CancelOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    final result = await _orderRepository.cancelOrder(event.orderId, event.reason);
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
      ReorderOrder event, Emitter<OrderState> emit) async {
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
      RateOrder event, Emitter<OrderState> emit) async {
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
      DownloadInvoice event, Emitter<OrderState> emit) async {
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

  void _onStatusUpdate(StatusUpdate event, Emitter<OrderState> emit) {
    // Here we can update the local list state if the order is in the list
    final data = event.payload;
    final id = data['orderId'] ?? data['_id'];
    if (id == null) return;

    final index = _accumulated.indexWhere((o) => o['_id'] == id || o['id'] == id);
    if (index != -1) {
      _logger.d('Updating order $id in list from WS');
      _accumulated[index] = {
        ..._accumulated[index],
        ...data,
      };
      emit(OrderState.ordersLoaded(List.unmodifiable(_accumulated)));
    }
  }
}

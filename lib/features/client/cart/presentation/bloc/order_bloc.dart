import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../../data/datasources/order_service.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService _orderService;
  final Logger _logger = Logger();

  OrderBloc(this._orderService) : super(const OrderState.initial()) {
    on<_CreateOrder>(_onCreateOrder);
    on<_LoadOrders>(_onLoadOrders);
    on<_CancelOrder>(_onCancelOrder);
    on<_RateOrder>(_onRateOrder);
  }

  Future<void> _onCreateOrder(_CreateOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final res = await _orderService.createOrder(event.payload);
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data = body['data'] as Map<String, dynamic>? ?? body;
        final orderId = data['_id']?.toString() ?? data['id']?.toString() ?? '';
        final paymentUrl = data['paymentUrl'] as String? ??
            (data['payment'] as Map<String, dynamic>?)?['paymentUrl'] as String?;
        emit(OrderState.created(orderId: orderId, paymentUrl: paymentUrl));
      } else {
        final msg = _extractError(res.body, 'Impossible de créer la commande.');
        emit(OrderState.error(msg));
      }
    } catch (e) {
      _logger.e('Error creating order: $e');
      emit(const OrderState.error('Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  Future<void> _onLoadOrders(_LoadOrders event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final res = await _orderService.getOrders();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List<dynamic>? ?? [];
        emit(OrderState.ordersLoaded(data.cast<Map<String, dynamic>>()));
      } else {
        emit(const OrderState.error('Impossible de charger les commandes.'));
      }
    } catch (e) {
      _logger.e('Error loading orders: $e');
      emit(const OrderState.error('Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  Future<void> _onCancelOrder(_CancelOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final res = await _orderService.cancelOrder(event.orderId);
      if (res.isSuccessful) {
        emit(const OrderState.cancelled());
      } else {
        final msg = _extractError(res.body, 'Impossible d\'annuler la commande.');
        emit(OrderState.error(msg));
      }
    } catch (e) {
      _logger.e('Error cancelling order: $e');
      emit(const OrderState.error('Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  Future<void> _onRateOrder(_RateOrder event, Emitter<OrderState> emit) async {
    emit(const OrderState.loading());
    try {
      final res = await _orderService.rateOrder(event.orderId, {
        'rating': event.rating,
        if (event.comment != null) 'comment': event.comment,
      });
      if (res.isSuccessful) {
        emit(const OrderState.rated());
      } else {
        final msg = _extractError(res.body, 'Impossible d\'envoyer l\'avis.');
        emit(OrderState.error(msg));
      }
    } catch (e) {
      _logger.e('Error rating order: $e');
      emit(const OrderState.error('Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  String _extractError(dynamic body, String fallback) {
    try {
      return (body as Map<String, dynamic>)['message']?.toString() ?? fallback;
    } catch (_) {
      return fallback;
    }
  }
}

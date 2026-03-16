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
    on<_CreateOrder>((event, emit) async {
      emit(const OrderState.loading());
      try {
        final res = await _orderService.createOrder(event.payload);
        if (res.isSuccessful && res.body != null) {
          final data = res.body!;
          final orderId = data['order_id']?.toString() ?? 'unknown_id';
          final paymentUrl = data['authorization_url']?.toString();
          
          emit(OrderState.created(orderId, paymentUrl));
        } else {
          emit(const OrderState.error("Échec de la création de la commande."));
        }
      } catch (e) {
        _logger.e("Error creating order: $e");
        emit(OrderState.error("Erreur réseau: $e"));
      }
    });

    on<_FetchMyOrders>((event, emit) async {
      emit(const OrderState.loading());
      try {
        final res = await _orderService.getMyOrders();
        if (res.isSuccessful && res.body != null) {
          final data = res.body?['data'] as List<dynamic>? ?? [];
          final orders = data.map((e) => e as Map<String, dynamic>).toList();
          emit(OrderState.loaded(orders));
        } else {
          emit(const OrderState.error("Impossible de récupérer l'historique."));
        }
      } catch (e) {
        _logger.e("Error loading orders: $e");
        emit(OrderState.error("Erreur réseau: $e"));
      }
    });
  }
}

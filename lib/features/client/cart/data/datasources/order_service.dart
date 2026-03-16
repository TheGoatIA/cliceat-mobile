import 'package:chopper/chopper.dart';

part 'order_service.chopper.dart';

/// Orders endpoints — base: /orders
@ChopperApi(baseUrl: '/orders')
abstract class OrderService extends ChopperService {
  static OrderService create([ChopperClient? client]) => _$OrderService(client);

  /// POST /orders — create a new order
  @POST()
  Future<Response<Map<String, dynamic>>> createOrder(
      @Body() Map<String, dynamic> body);

  /// GET /orders — list client orders
  @GET()
  Future<Response<Map<String, dynamic>>> getOrders();

  /// GET /orders/{id} — get order details
  @GET(path: '/{id}')
  Future<Response<Map<String, dynamic>>> getOrderById(@Path('id') String id);

  /// POST /orders/{id}/cancel — cancel an order
  @POST(path: '/{id}/cancel')
  Future<Response<Map<String, dynamic>>> cancelOrder(@Path('id') String id);

  /// POST /orders/{id}/rate — rate a delivered order
  @POST(path: '/{id}/rate')
  Future<Response<Map<String, dynamic>>> rateOrder(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}

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

  /// GET /orders — list client orders (paginated)
  @GET()
  Future<Response<Map<String, dynamic>>> getOrders({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

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

  /// POST /orders/{id}/reorder — create a new order from a past order
  @POST(path: '/{id}/reorder')
  Future<Response<Map<String, dynamic>>> reorderOrder(
      @Path('id') String id);
}

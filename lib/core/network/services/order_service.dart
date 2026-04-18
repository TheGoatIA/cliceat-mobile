import 'package:chopper/chopper.dart';

part 'order_service.chopper.dart';

@ChopperApi(baseUrl: '/orders')
abstract class OrderService extends ChopperService {
  static OrderService create([ChopperClient? client]) =>
      _$OrderService(client);

  @POST()
  Future<Response> createOrder(@Body() Map<String, dynamic> body);

  @GET(path: '/me')
  Future<Response> getMyOrders();

  @GET(path: '/{id}')
  Future<Response> getOrder(@Path('id') String id);

  @PATCH(path: '/{id}/status')
  Future<Response> updateOrderStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/{id}/cancel')
  Future<Response> cancelOrder(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/{id}/rate')
  Future<Response> rateOrder(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}

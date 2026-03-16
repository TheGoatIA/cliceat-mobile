import 'package:chopper/chopper.dart';

part 'order_service.chopper.dart';

@ChopperApi(baseUrl: '/orders')
abstract class OrderService extends ChopperService {
  static OrderService create([ChopperClient? client]) => _$OrderService(client);

  @POST()
  Future<Response<Map<String, dynamic>>> createOrder(
    @Body() Map<String, dynamic> orderData,
  );

  @GET(path: '/me')
  Future<Response<Map<String, dynamic>>> getMyOrders();

  @GET(path: '/{id}')
  Future<Response<Map<String, dynamic>>> getOrderDetails(
    @Path('id') String id,
  );

  @POST(path: '/{id}/rate')
  Future<Response<Map<String, dynamic>>> rateOrder(
    @Path('id') String id,
    @Body() Map<String, dynamic> ratingData,
  );
}

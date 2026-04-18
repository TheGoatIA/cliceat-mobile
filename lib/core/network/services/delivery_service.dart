import 'package:chopper/chopper.dart';

part 'delivery_service.chopper.dart';

@ChopperApi(baseUrl: '/delivery')
abstract class DeliveryService extends ChopperService {
  static DeliveryService create([ChopperClient? client]) =>
      _$DeliveryService(client);

  @PATCH(path: '/me/status')
  Future<Response> updateDriverStatus(@Body() Map<String, dynamic> body);

  @PATCH(path: '/me/location')
  Future<Response> updateLocation(@Body() Map<String, dynamic> body);

  @GET(path: '/me/orders')
  Future<Response> getDriverOrders();

  @GET(path: '/me/earnings')
  Future<Response> getDriverEarnings();

  @PATCH(path: '/orders/{id}/accept')
  Future<Response> acceptMission(@Path('id') String id);

  @PATCH(path: '/orders/{id}/reject')
  Future<Response> rejectMission(@Path('id') String id);

  @POST(path: '/orders/{id}/pickup')
  Future<Response> confirmPickup(@Path('id') String id);

  @POST(path: '/orders/{id}/delivered')
  Future<Response> confirmDelivery(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}

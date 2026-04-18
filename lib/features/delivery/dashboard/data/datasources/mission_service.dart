import 'package:chopper/chopper.dart';

part 'mission_service.chopper.dart';

/// Delivery mission endpoints — base: /delivery
@ChopperApi(baseUrl: '/delivery')
abstract class MissionService extends ChopperService {
  static MissionService create([ChopperClient? client]) =>
      _$MissionService(client);

  /// GET /delivery/me/orders — current assigned orders
  @GET(path: '/me/orders')
  Future<Response<Map<String, dynamic>>> getMyOrders();

  /// PATCH /delivery/orders/{id}/accept
  @PATCH(path: '/orders/{id}/accept')
  Future<Response<Map<String, dynamic>>> acceptMission(
      @Path('id') String id);

  /// PATCH /delivery/orders/{id}/reject
  @PATCH(path: '/orders/{id}/reject')
  Future<Response<Map<String, dynamic>>> rejectMission(
      @Path('id') String id);

  /// POST /delivery/orders/{id}/pickup
  @POST(path: '/orders/{id}/pickup')
  Future<Response<Map<String, dynamic>>> confirmPickup(
      @Path('id') String id);

  /// POST /delivery/orders/{id}/confirm (replaces /delivered)
  @POST(path: '/orders/{id}/confirm')
  Future<Response<Map<String, dynamic>>> confirmDelivery(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  /// POST /delivery/orders/{id}/report (issue signaling)
  @Deprecated('Endpoint does not exist on backend')
  @POST(path: '/orders/{id}/report')
  Future<Response<Map<String, dynamic>>> reportMission(
    @Path('id') String id,
    @Body() Map<String, dynamic> reportData,
  );
}

import 'package:chopper/chopper.dart';

part 'mission_service.chopper.dart';

<<<<<<< HEAD
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

  /// POST /delivery/orders/{id}/delivered
  @POST(path: '/orders/{id}/delivered')
  Future<Response<Map<String, dynamic>>> confirmDelivery(
=======
@ChopperApi(baseUrl: '/missions')
abstract class MissionService extends ChopperService {
  static MissionService create([ChopperClient? client]) => _$MissionService(client);

  @GET()
  Future<Response<Map<String, dynamic>>> getActiveMissions();

  @PATCH(path: '/{id}/accept')
  Future<Response<Map<String, dynamic>>> acceptMission(@Path('id') String id);

  @PATCH(path: '/{id}/reject')
  Future<Response<Map<String, dynamic>>> rejectMission(@Path('id') String id);

  @PATCH(path: '/{id}/status')
  Future<Response<Map<String, dynamic>>> updateMissionStatus(
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

<<<<<<< HEAD
  /// POST /delivery/orders/{id}/report (issue signaling)
  @Deprecated('Endpoint does not exist on backend')
  @POST(path: '/orders/{id}/report')
=======
  @POST(path: '/{id}/report')
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
  Future<Response<Map<String, dynamic>>> reportMission(
    @Path('id') String id,
    @Body() Map<String, dynamic> reportData,
  );
}

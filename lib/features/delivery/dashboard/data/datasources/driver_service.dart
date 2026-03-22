import 'package:chopper/chopper.dart';

part 'driver_service.chopper.dart';

<<<<<<< HEAD
/// Driver profile/status endpoints — base: /delivery
@ChopperApi(baseUrl: '/delivery')
abstract class DriverService extends ChopperService {
  static DriverService create([ChopperClient? client]) =>
      _$DriverService(client);

  /// GET /delivery/me/earnings
  @GET(path: '/me/earnings')
  Future<Response<Map<String, dynamic>>> getMyEarnings();

  /// PATCH /delivery/me/status  — { isOnline: bool }
  @PATCH(path: '/me/status')
  Future<Response<Map<String, dynamic>>> updateStatus(
      @Body() Map<String, dynamic> statusData);

  /// PATCH /delivery/me/location — { lat, lng }
  @PATCH(path: '/me/location')
  Future<Response<Map<String, dynamic>>> updateLocation(
      @Body() Map<String, dynamic> locationData);
=======
@ChopperApi(baseUrl: '/drivers')
abstract class DriverService extends ChopperService {
  static DriverService create([ChopperClient? client]) => _$DriverService(client);

  @GET(path: '/me/earnings')
  Future<Response<Map<String, dynamic>>> getMyEarnings();

  @PATCH(path: '/me/status')
  Future<Response<Map<String, dynamic>>> updateStatus(
    @Body() Map<String, dynamic> statusData,
  );
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

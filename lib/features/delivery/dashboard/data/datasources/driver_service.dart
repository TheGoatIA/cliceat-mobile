import 'package:chopper/chopper.dart';

part 'driver_service.chopper.dart';

/// Driver profile/status endpoints — base: /delivery
@ChopperApi(baseUrl: '/delivery')
abstract class DriverService extends ChopperService {
  static DriverService create([ChopperClient? client]) =>
      _$DriverService(client);

  /// GET /delivery/me
  @GET(path: '/me')
  Future<Response<Map<String, dynamic>>> getProfile();

  /// GET /delivery/me/earnings
  @GET(path: '/me/earnings')
  Future<Response<Map<String, dynamic>>> getMyEarnings();

  /// PATCH /delivery/me/status  — { isOnline: bool }
  @PATCH(path: '/me/status')
  Future<Response<Map<String, dynamic>>> updateStatus(
    @Body() Map<String, dynamic> statusData,
  );

  /// PATCH /delivery/me/location — { lat, lng }
  @PATCH(path: '/me/location')
  Future<Response<Map<String, dynamic>>> updateLocation(
    @Body() Map<String, dynamic> locationData,
  );

  /// GET /delivery/me/ranking
  @GET(path: '/me/ranking')
  Future<Response<Map<String, dynamic>>> getRanking();

  /// GET /delivery/me/goal
  @GET(path: '/me/goal')
  Future<Response<Map<String, dynamic>>> getGoal();

  /// PUT /delivery/me/goal — { amount: int }
  @PUT(path: '/me/goal')
  Future<Response<Map<String, dynamic>>> setGoal(
    @Body() Map<String, dynamic> goalData,
  );

  /// POST /delivery/register (Multipart)
  @POST(path: '/register')
  @Multipart()
  Future<Response<Map<String, dynamic>>> registerDriver(
    @Part('name') String name,
    @Part('email') String email,
    @Part('phone') String phone,
    @Part('password') String password,
    @Part('city') String city,
    @Part('vehicleType') String vehicleType,
    @Part('vehiclePlate') String vehiclePlate,
    @PartFile('idCard') String idCardPath,
    @PartFile('license') String licensePath,
    @PartFile('photo') String photoPath,
  );
}

import 'package:chopper/chopper.dart';

part 'user_service.chopper.dart';

@ChopperApi(baseUrl: '/users')
abstract class UserService extends ChopperService {
  static UserService create([ChopperClient? client]) => _$UserService(client);

  /// GET /users/me
  @GET(path: '/me')
  Future<Response<Map<String, dynamic>>> getMe();

  /// PATCH /users/me
  @PATCH(path: '/me')
  Future<Response<Map<String, dynamic>>> updateMe(
      @Body() Map<String, dynamic> body);

  /// POST /users/me/device-token — register FCM token with locale
  @POST(path: '/me/device-token')
  Future<Response<Map<String, dynamic>>> registerFcmToken(
      @Body() Map<String, dynamic> body);

  /// DELETE /users/me/device-token — unregister FCM token on logout
  @DELETE(path: '/me/device-token')
  Future<Response<Map<String, dynamic>>> unregisterFcmToken(
      @Body() Map<String, dynamic> body);

  /// GET /users/me/addresses
  @GET(path: '/me/addresses')
  Future<Response<Map<String, dynamic>>> getAddresses();

  /// POST /users/me/addresses
  @POST(path: '/me/addresses')
  Future<Response<Map<String, dynamic>>> addAddress(
      @Body() Map<String, dynamic> body);

  /// DELETE /users/me/addresses/{id}
  @DELETE(path: '/me/addresses/{id}')
  Future<Response<Map<String, dynamic>>> deleteAddress(
      @Path('id') String id);

  /// GET /users/me/loyalty
  @GET(path: '/me/loyalty')
  Future<Response<Map<String, dynamic>>> getLoyalty();

  /// GET /users/me/notifications
  @GET(path: '/me/notifications')
  Future<Response<Map<String, dynamic>>> getNotifications(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// PATCH /users/me/notifications/{id}/read
  @PATCH(path: '/me/notifications/{id}/read')
  Future<Response<Map<String, dynamic>>> markNotificationRead(
    @Path('id') String id,
  );

  /// DELETE /users/me/notifications/{id}
  @DELETE(path: '/me/notifications/{id}')
  Future<Response<Map<String, dynamic>>> deleteNotification(
    @Path('id') String id,
  );
}

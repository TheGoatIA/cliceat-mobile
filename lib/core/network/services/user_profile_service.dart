import 'package:chopper/chopper.dart';

part 'user_profile_service.chopper.dart';

@ChopperApi(baseUrl: '/users')
abstract class UserProfileService extends ChopperService {
  static UserProfileService create([ChopperClient? client]) =>
      _$UserProfileService(client);

  @GET(path: '/me')
  Future<Response> getProfile();

  @PATCH(path: '/me')
  Future<Response> updateProfile(@Body() Map<String, dynamic> body);

  @GET(path: '/me/addresses')
  Future<Response> getAddresses();

  @POST(path: '/me/addresses')
  Future<Response> addAddress(@Body() Map<String, dynamic> body);

  @DELETE(path: '/me/addresses/{id}')
  Future<Response> deleteAddress(@Path('id') String id);

  @GET(path: '/me/loyalty')
  Future<Response> getLoyalty();

  @GET(path: '/me/loyalty/history')
  Future<Response> getLoyaltyHistory();

  @POST(path: '/me/loyalty/redeem')
  Future<Response> redeemLoyalty(@Body() Map<String, dynamic> body);

  @POST(path: '/me/device-token')
  Future<Response> registerDeviceToken(@Body() Map<String, dynamic> body);
}

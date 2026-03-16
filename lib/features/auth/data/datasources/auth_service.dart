import 'package:chopper/chopper.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: '/auth')
abstract class AuthService extends ChopperService {
  static AuthService create([ChopperClient? client]) => _$AuthService(client);

  @POST(path: '/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @POST(path: '/phone/send-otp')
  Future<Response> sendOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/phone/verify-otp')
  Future<Response> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/refresh')
  Future<Response> refreshToken();
}

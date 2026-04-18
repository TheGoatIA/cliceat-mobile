import 'package:chopper/chopper.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: '/auth')
abstract class AuthService extends ChopperService {
  static AuthService create([ChopperClient? client]) => _$AuthService(client);

  @POST(path: '/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @POST(path: '/register')
  Future<Response> register(@Body() Map<String, dynamic> body);

  @POST(path: '/firebase')
  Future<Response> firebaseAuth(@Body() Map<String, dynamic> body);

  @POST(path: '/phone/send-otp')
  Future<Response> sendOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/phone/verify-otp')
  Future<Response> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/refresh')
  Future<Response> refreshToken();

  @POST(path: '/logout')
  Future<Response> logout();

  @POST(path: '/forgot-password')
  Future<Response> forgotPassword(@Body() Map<String, dynamic> body);

  @POST(path: '/delivery/login')
  Future<Response> loginDelivery(@Body() Map<String, dynamic> body);
}

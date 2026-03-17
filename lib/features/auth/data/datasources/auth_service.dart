import 'package:chopper/chopper.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: '/auth')
abstract class AuthService extends ChopperService {
  static AuthService create([ChopperClient? client]) => _$AuthService(client);

  @POST(path: '/register')
  Future<Response> register(@Body() Map<String, dynamic> body);

  @POST(path: '/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @POST(path: '/phone/send-otp')
  Future<Response> sendOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/phone/verify-otp')
  Future<Response> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/refresh')
  Future<Response> refreshToken();

  @POST(path: '/logout')
  Future<Response> logout();

  /// Firebase social auth (Google or Apple)
  @POST(path: '/firebase')
  Future<Response> loginWithFirebase(@Body() Map<String, dynamic> body);

  // Kept for backward compat aliases
  @POST(path: '/google')
  Future<Response> loginWithGoogle(@Body() Map<String, dynamic> body);

  @POST(path: '/apple')
  Future<Response> loginWithApple(@Body() Map<String, dynamic> body);

  @POST(path: '/forgot-password')
  Future<Response> forgotPassword(@Body() Map<String, dynamic> body);

  @POST(path: '/reset-password')
  Future<Response> resetPassword(@Body() Map<String, dynamic> body);

  @GET(path: '/verify-email/{token}')
  Future<Response> verifyEmail(@Path('token') String token);

  @POST(path: '/resend-verification-email')
  Future<Response> resendVerificationEmail(@Body() Map<String, dynamic> body);
}

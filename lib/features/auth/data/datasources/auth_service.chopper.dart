// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'auth_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthService extends AuthService {
  _$AuthService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthService;

  @override
  Future<Response<dynamic>> login(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/login');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> register(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/register');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> firebaseAuth(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/firebase');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendOtp(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/phone/send-otp');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> verifyOtp(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/phone/verify-otp');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> refreshToken() {
    final Uri $url = Uri.parse('/auth/refresh');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> logout() {
    final Uri $url = Uri.parse('/auth/logout');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> forgotPassword(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/forgot-password');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> loginDelivery(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/delivery/login');
    final Request $request = Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }
}

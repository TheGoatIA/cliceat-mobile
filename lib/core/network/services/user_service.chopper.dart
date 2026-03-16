// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'user_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$UserService extends UserService {
  _$UserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = UserService;

  @override
  Future<Response<Map<String, dynamic>>> getMe() {
    final Uri $url = Uri.parse('/users/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> updateMe(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me');
    final $body = body;
    final Request $request =
        Request('PATCH', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> registerFcmToken(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me/device-token');
    final $body = body;
    final Request $request =
        Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getAddresses() {
    final Uri $url = Uri.parse('/users/me/addresses');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> addAddress(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me/addresses');
    final $body = body;
    final Request $request =
        Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> deleteAddress(String id) {
    final Uri $url = Uri.parse('/users/me/addresses/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getLoyalty() {
    final Uri $url = Uri.parse('/users/me/loyalty');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

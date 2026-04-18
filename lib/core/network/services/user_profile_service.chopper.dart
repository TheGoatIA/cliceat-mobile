// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'user_profile_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$UserProfileService extends UserProfileService {
  _$UserProfileService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = UserProfileService;

  @override
  Future<Response<dynamic>> getProfile() {
    final Uri $url = Uri.parse('/users/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateProfile(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAddresses() {
    final Uri $url = Uri.parse('/users/me/addresses');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addAddress(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me/addresses');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteAddress(String id) {
    final Uri $url = Uri.parse('/users/me/addresses/$id');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLoyalty() {
    final Uri $url = Uri.parse('/users/me/loyalty');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLoyaltyHistory() {
    final Uri $url = Uri.parse('/users/me/loyalty/history');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> redeemLoyalty(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me/loyalty/redeem');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> registerDeviceToken(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/users/me/device-token');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}

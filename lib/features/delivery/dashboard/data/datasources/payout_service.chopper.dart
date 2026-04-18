// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'payout_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PayoutService extends PayoutService {
  _$PayoutService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PayoutService;

  @override
  Future<Response<Map<String, dynamic>>> getPayouts() {
    final Uri $url = Uri.parse('/drivers/me/payouts');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> requestPayout(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/drivers/me/payouts');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getPayoutAccount() {
    final Uri $url = Uri.parse('/drivers/me/payout-account');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> updatePayoutAccount(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/drivers/me/payout-account');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

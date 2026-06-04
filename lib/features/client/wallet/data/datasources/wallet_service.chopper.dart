// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'wallet_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$WalletService extends WalletService {
  _$WalletService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = WalletService;

  @override
  Future<Response<Map<String, dynamic>>> recharge(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/wallet/recharge');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> payOrder(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/wallet/pay');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

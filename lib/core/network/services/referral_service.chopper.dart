// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'referral_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReferralService extends ReferralService {
  _$ReferralService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReferralService;

  @override
  Future<Response<Map<String, dynamic>>> getMyCode() {
    final Uri $url = Uri.parse('/referrals/my-code');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> applyCode(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/referrals/apply');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getStats() {
    final Uri $url = Uri.parse('/referrals/stats');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'tracking_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TrackingService extends TrackingService {
  _$TrackingService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TrackingService;

  @override
  Future<Response<Map<String, dynamic>>> getTracking(String orderId) {
    final Uri $url = Uri.parse('/tracking/${orderId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getEta(String orderId) {
    final Uri $url = Uri.parse('/tracking/${orderId}/eta');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

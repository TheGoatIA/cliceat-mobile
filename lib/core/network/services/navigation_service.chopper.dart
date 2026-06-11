// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'navigation_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$NavigationService extends NavigationService {
  _$NavigationService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = NavigationService;

  @override
  Future<Response<Map<String, dynamic>>> computeRoute(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/navigation/route');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> reroute(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/navigation/reroute');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getOrderETA(String orderId) {
    final Uri $url = Uri.parse('/navigation/eta/${orderId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getTrafficZones({String? city}) {
    final Uri $url = Uri.parse('/navigation/traffic');
    final Map<String, dynamic> $params = <String, dynamic>{'city': city};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

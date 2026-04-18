// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'delivery_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DeliveryService extends DeliveryService {
  _$DeliveryService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DeliveryService;

  @override
  Future<Response<dynamic>> updateDriverStatus(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/delivery/me/status');
    final Request $request =
        Request('PATCH', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateLocation(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/delivery/me/location');
    final Request $request =
        Request('PATCH', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDriverOrders() {
    final Uri $url = Uri.parse('/delivery/me/orders');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDriverEarnings() {
    final Uri $url = Uri.parse('/delivery/me/earnings');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> acceptMission(String id) {
    final Uri $url = Uri.parse('/delivery/orders/$id/accept');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> rejectMission(String id) {
    final Uri $url = Uri.parse('/delivery/orders/$id/reject');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> confirmPickup(String id) {
    final Uri $url = Uri.parse('/delivery/orders/$id/pickup');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> confirmDelivery(
      String id, Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/delivery/orders/$id/delivered');
    final Request $request =
        Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }
}

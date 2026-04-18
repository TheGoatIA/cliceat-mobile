// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'order_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$OrderService extends OrderService {
  _$OrderService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = OrderService;

  @override
  Future<Response<dynamic>> createOrder(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/orders');
    final Request $request =
        Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMyOrders() {
    final Uri $url = Uri.parse('/orders/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getOrder(String id) {
    final Uri $url = Uri.parse('/orders/$id');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateOrderStatus(
      String id, Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/orders/$id/status');
    final Request $request =
        Request('PATCH', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> cancelOrder(
      String id, Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/orders/$id/cancel');
    final Request $request =
        Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> rateOrder(String id, Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/orders/$id/rate');
    final Request $request =
        Request('POST', $url, client.baseUrl, body: body);
    return client.send<dynamic, dynamic>($request);
  }
}

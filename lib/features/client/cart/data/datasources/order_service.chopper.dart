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
  Future<Response<Map<String, dynamic>>> createOrder(
    Map<String, dynamic> orderData,
  ) {
    final Uri $url = Uri.parse('/orders');
    final $body = orderData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getMyOrders() {
    final Uri $url = Uri.parse('/orders/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getOrderDetails(String id) {
    final Uri $url = Uri.parse('/orders/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> rateOrder(
    String id,
    Map<String, dynamic> ratingData,
  ) {
    final Uri $url = Uri.parse('/orders/${id}/rate');
    final $body = ratingData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

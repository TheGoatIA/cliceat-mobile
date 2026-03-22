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
<<<<<<< HEAD
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/orders');
    final $body = body;
=======
    Map<String, dynamic> orderData,
  ) {
    final Uri $url = Uri.parse('/orders');
    final $body = orderData;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
<<<<<<< HEAD
  Future<Response<Map<String, dynamic>>> getOrders({
    int page = 1,
    int limit = 20,
  }) {
    final Uri $url = Uri.parse('/orders');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
=======
  Future<Response<Map<String, dynamic>>> getMyOrders() {
    final Uri $url = Uri.parse('/orders/me');
    final Request $request = Request('GET', $url, client.baseUrl);
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
<<<<<<< HEAD
  Future<Response<Map<String, dynamic>>> getOrderById(String id) {
=======
  Future<Response<Map<String, dynamic>>> getOrderDetails(String id) {
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    final Uri $url = Uri.parse('/orders/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
<<<<<<< HEAD
  Future<Response<Map<String, dynamic>>> cancelOrder(String id) {
    final Uri $url = Uri.parse('/orders/${id}/cancel');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> rateOrder(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/orders/${id}/rate');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> reorderOrder(String id) {
    final Uri $url = Uri.parse('/orders/${id}/reorder');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<dynamic>> downloadInvoice(String id) {
    final Uri $url = Uri.parse('/orders/${id}/invoice/download');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
=======
  Future<Response<Map<String, dynamic>>> rateOrder(
    String id,
    Map<String, dynamic> ratingData,
  ) {
    final Uri $url = Uri.parse('/orders/${id}/rate');
    final $body = ratingData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

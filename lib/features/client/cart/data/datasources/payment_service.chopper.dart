// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'payment_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PaymentService extends PaymentService {
  _$PaymentService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PaymentService;

  @override
  Future<Response<Map<String, dynamic>>> initPayment(
    Map<String, dynamic> paymentData,
  ) {
    final Uri $url = Uri.parse('/payments/init');
    final $body = paymentData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getMyPayments() {
    final Uri $url = Uri.parse('/payments/me');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getPaymentStatus(String id) {
    final Uri $url = Uri.parse('/payments/${id}/status');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

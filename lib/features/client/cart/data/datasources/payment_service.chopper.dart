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
  Future<Response<Map<String, dynamic>>> initializePayment(
      Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/payments/initialize');
    final $body = body;
    final Request $request =
        Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> verifyPayment(String reference) {
    final Uri $url = Uri.parse('/payments/$reference/verify');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getPaymentMethods() {
    final Uri $url = Uri.parse('/payments/methods');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

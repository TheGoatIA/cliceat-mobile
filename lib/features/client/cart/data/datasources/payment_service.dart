import 'package:chopper/chopper.dart';

part 'payment_service.chopper.dart';

/// Payment endpoints — base: /payments
@ChopperApi(baseUrl: '/payments')
abstract class PaymentService extends ChopperService {
  static PaymentService create([ChopperClient? client]) =>
      _$PaymentService(client);

  /// POST /payments/initialize — initiate a NotchPay payment
  @POST(path: '/initialize')
  Future<Response<Map<String, dynamic>>> initializePayment(
      @Body() Map<String, dynamic> body);

  /// GET /payments/{reference}/verify — verify payment status
  @GET(path: '/{reference}/verify')
  Future<Response<Map<String, dynamic>>> verifyPayment(
      @Path('reference') String reference);

  /// POST /payments/webhook — internal (backend handles this, not mobile)
  /// Exposed for reference only — not called from mobile directly.
  @GET(path: '/methods')
  Future<Response<Map<String, dynamic>>> getPaymentMethods();
}

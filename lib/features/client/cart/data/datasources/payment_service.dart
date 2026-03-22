import 'package:chopper/chopper.dart';

part 'payment_service.chopper.dart';

<<<<<<< HEAD
/// Payment endpoints — base: /payments
@ChopperApi(baseUrl: '/payments')
abstract class PaymentService extends ChopperService {
  static PaymentService create([ChopperClient? client]) =>
      _$PaymentService(client);

  /// POST /payments/init — initiate a NotchPay payment
  @POST(path: '/init')
  Future<Response<Map<String, dynamic>>> initializePayment(
      @Body() Map<String, dynamic> body);

  /// GET /payments/{id}/status — verify payment status
  @GET(path: '/{id}/status')
  Future<Response<Map<String, dynamic>>> verifyPayment(
      @Path('id') String id);

  /// POST /payments/webhook — internal (backend handles this, not mobile)
  /// Exposed for reference only — not called from mobile directly.
  @GET(path: '/methods')
  Future<Response<Map<String, dynamic>>> getPaymentMethods();
=======
@ChopperApi(baseUrl: '/payments')
abstract class PaymentService extends ChopperService {
  static PaymentService create([ChopperClient? client]) => _$PaymentService(client);

  @POST(path: '/init')
  Future<Response<Map<String, dynamic>>> initPayment(
    @Body() Map<String, dynamic> paymentData,
  );

  @GET(path: '/me')
  Future<Response<Map<String, dynamic>>> getMyPayments();

  @GET(path: '/{id}/status')
  Future<Response<Map<String, dynamic>>> getPaymentStatus(
    @Path('id') String id,
  );
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

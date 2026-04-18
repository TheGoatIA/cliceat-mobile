import 'package:chopper/chopper.dart';

part 'payment_service.chopper.dart';

@ChopperApi(baseUrl: '/payments')
abstract class PaymentService extends ChopperService {
  static PaymentService create([ChopperClient? client]) =>
      _$PaymentService(client);

  @POST(path: '/init')
  Future<Response> initPayment(@Body() Map<String, dynamic> body);

  @POST(path: '/refund')
  Future<Response> refund(@Body() Map<String, dynamic> body);

  @POST(path: '/wallet/recharge')
  Future<Response> rechargeWallet(@Body() Map<String, dynamic> body);

  @POST(path: '/wallet/pay')
  Future<Response> walletPay(@Body() Map<String, dynamic> body);

  @GET(path: '/me')
  Future<Response> getMyPayments();

  @GET(path: '/{id}/status')
  Future<Response> getPaymentStatus(@Path('id') String id);
}

import 'package:chopper/chopper.dart';

part 'payment_service.chopper.dart';

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
}

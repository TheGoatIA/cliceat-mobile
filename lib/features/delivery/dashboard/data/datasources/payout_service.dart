import 'package:chopper/chopper.dart';

part 'payout_service.chopper.dart';

@ChopperApi(baseUrl: '/payouts')
abstract class PayoutService extends ChopperService {
  static PayoutService create([ChopperClient? client]) => _$PayoutService(client);

  @GET(path: '/history')
  Future<Response<Map<String, dynamic>>> getPayouts();

  @POST(path: '/request')
  Future<Response<Map<String, dynamic>>> requestPayout(@Body() Map<String, dynamic> body);

  @GET(path: '/account')
  Future<Response<Map<String, dynamic>>> getPayoutAccount();

  @POST(path: '/account')
  Future<Response<Map<String, dynamic>>> updatePayoutAccount(@Body() Map<String, dynamic> body);
}

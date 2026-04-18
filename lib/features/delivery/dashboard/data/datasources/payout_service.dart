import 'package:chopper/chopper.dart';

part 'payout_service.chopper.dart';

@ChopperApi(baseUrl: '/drivers/me')
abstract class PayoutService extends ChopperService {
  static PayoutService create([ChopperClient? client]) => _$PayoutService(client);

  @GET(path: '/payouts')
  Future<Response<Map<String, dynamic>>> getPayouts();

  @POST(path: '/payouts')
  Future<Response<Map<String, dynamic>>> requestPayout(@Body() Map<String, dynamic> body);

  @GET(path: '/payout-account')
  Future<Response<Map<String, dynamic>>> getPayoutAccount();

  @PUT(path: '/payout-account')
  Future<Response<Map<String, dynamic>>> updatePayoutAccount(@Body() Map<String, dynamic> body);
}

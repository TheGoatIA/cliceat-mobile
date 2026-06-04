import 'package:chopper/chopper.dart';

part 'referral_service.chopper.dart';

@ChopperApi(baseUrl: '/referrals')
abstract class ReferralService extends ChopperService {
  static ReferralService create([ChopperClient? client]) =>
      _$ReferralService(client);

  @GET(path: '/my-code')
  Future<Response<Map<String, dynamic>>> getMyCode();

  @POST(path: '/apply')
  Future<Response<Map<String, dynamic>>> applyCode(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/stats')
  Future<Response<Map<String, dynamic>>> getStats();
}

import 'package:chopper/chopper.dart';

part 'wallet_service.chopper.dart';

@ChopperApi(baseUrl: '/wallet')
abstract class WalletService extends ChopperService {
  static WalletService create([ChopperClient? client]) =>
      _$WalletService(client);

  @POST(path: '/recharge')
  Future<Response<Map<String, dynamic>>> recharge(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/pay')
  Future<Response<Map<String, dynamic>>> payOrder(
    @Body() Map<String, dynamic> body,
  );
}

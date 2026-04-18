import 'package:chopper/chopper.dart';

part 'platform_service.chopper.dart';

@ChopperApi(baseUrl: '/platform')
abstract class PlatformService extends ChopperService {
  static PlatformService create([ChopperClient? client]) =>
      _$PlatformService(client);

  @GET(path: '/config')
  Future<Response<Map<String, dynamic>>> getConfig();
}

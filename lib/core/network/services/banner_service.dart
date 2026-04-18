import 'package:chopper/chopper.dart';

part 'banner_service.chopper.dart';

@ChopperApi(baseUrl: '/banners')
abstract class BannerService extends ChopperService {
  static BannerService create([ChopperClient? client]) =>
      _$BannerService(client);

  @GET(path: '/')
  Future<Response> getBanners();
}

import 'package:chopper/chopper.dart';

part 'coupon_service.chopper.dart';

@ChopperApi(baseUrl: '/coupons')
abstract class CouponService extends ChopperService {
  static CouponService create([ChopperClient? client]) =>
      _$CouponService(client);

  /// GET /coupons/validate?code=...
  @GET(path: '/validate')
  Future<Response<Map<String, dynamic>>> validateCoupon(
      @Query('code') String code);

  /// GET /coupons/banners — active marketing banners
  @GET(path: '/banners')
  Future<Response<Map<String, dynamic>>> getBanners();

  /// GET /coupons/available — user-specific coupons
  @GET(path: '/available')
  Future<Response<Map<String, dynamic>>> getAvailableCoupons();
}

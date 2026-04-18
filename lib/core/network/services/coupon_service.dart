import 'package:chopper/chopper.dart';

part 'coupon_service.chopper.dart';

@ChopperApi(baseUrl: '/coupons')
abstract class CouponService extends ChopperService {
  static CouponService create([ChopperClient? client]) =>
      _$CouponService(client);

  @GET(path: '/validate/{code}')
  Future<Response> validateCoupon(@Path('code') String code);

  @GET(path: '/')
  Future<Response> getAvailableCoupons();
}

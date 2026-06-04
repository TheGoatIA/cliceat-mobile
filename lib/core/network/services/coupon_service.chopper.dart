// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'coupon_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CouponService extends CouponService {
  _$CouponService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CouponService;

  @override
  Future<Response<Map<String, dynamic>>> validateCoupon(String code) {
    final Uri $url = Uri.parse('/coupons/validate');
    final Map<String, dynamic> $params = <String, dynamic>{'code': code};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getBanners() {
    final Uri $url = Uri.parse('/coupons/banners');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getAvailableCoupons() {
    final Uri $url = Uri.parse('/coupons/available');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

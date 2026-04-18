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
  Future<Response<dynamic>> validateCoupon(String code) {
    final Uri $url = Uri.parse('/coupons/validate/$code');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAvailableCoupons() {
    final Uri $url = Uri.parse('/coupons/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}

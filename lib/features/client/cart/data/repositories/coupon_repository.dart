import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/cart/data/models/coupon_model.dart';
import 'package:cliceat_app/features/client/banner/data/models/banner_model.dart';
import 'package:cliceat_app/core/network/services/coupon_service.dart';

/// Abstracts coupon validation and banner fetching.
@lazySingleton
class CouponRepository {
  final CouponService _service;

  CouponRepository(this._service);

  Future<Either<AppError, CouponModel>> validateCoupon(String code) async {
    try {
      final res = await _service.validateCoupon(code);
      if (res.isSuccessful && res.body != null) {
        return Right(CouponModel.fromJson(res.body!));
      }
      return Left(AppError.fromResponse(
          res.body, 'checkout.coupon_invalid',
          statusCode: res.statusCode));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<BannerModel>>> getBanners() async {
    try {
      final res = await _service.getBanners();
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['data'] as List<dynamic>? ?? [];
        return Right(raw
            .whereType<Map<String, dynamic>>()
            .map(BannerModel.fromJson)
            .toList());
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<CouponModel>>>
      getAvailableCoupons() async {
    try {
      final res = await _service.getAvailableCoupons();
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['data'] as List<dynamic>? ?? [];
        return Right(raw
            .whereType<Map<String, dynamic>>()
            .map(CouponModel.fromJson)
            .toList());
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }
}

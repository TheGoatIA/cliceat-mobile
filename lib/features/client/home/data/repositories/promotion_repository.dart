import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/home/data/datasources/promotion_service.dart';

@lazySingleton
class PromotionRepository {
  final PromotionService _promotionService;

  PromotionRepository(this._promotionService);

  Future<Either<AppError, List<Map<String, dynamic>>>> getActivePromotions() async {
    try {
      final res = await _promotionService.getActivePromotions();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List<dynamic>? ?? [];
        return Right(data.cast<Map<String, dynamic>>());
      }
      return Left(AppError.fromResponse(res.body, 'promotion.load_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<Map<String, dynamic>>>> getRestaurantPromotions(String restaurantId) async {
    try {
      final res = await _promotionService.getRestaurantPromotions(restaurantId);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List<dynamic>? ?? [];
        return Right(data.cast<Map<String, dynamic>>());
      }
      return Left(AppError.fromResponse(res.body, 'promotion.load_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }
}

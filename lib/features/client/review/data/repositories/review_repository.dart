import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/network/services/review_service.dart';
import '../models/review_model.dart';
import 'package:cliceat_app/core/data/local/daos/pending_actions_dao.dart';
import 'dart:convert';


@injectable
class ReviewRepository {
  final ReviewService _service;
  final PendingActionsDao _pendingActionsDao;
  ReviewRepository(this._service, this._pendingActionsDao);

  Future<Either<AppError, List<ReviewModel>>> getRestaurantReviews(String restaurantId, {int page = 1}) async {
    try {
      final res = await _service.getRestaurantReviews(restaurantId, page: page);
      if (res.isSuccessful && res.body != null) {
        // Backend returns: {success, items: [...], total, page, hasNext}
        // Fallback also checks 'data' for forward-compatibility
        final raw = res.body!['items'] ?? res.body!['data'] ?? [];
        final list = raw is List ? raw : [];
        return Right(list.whereType<Map<String, dynamic>>().map(ReviewModel.fromJson).toList());
      }
      return Left(AppError.fromResponse(res.body, 'review.error_load'));
    } catch (_) {
      return Left(const AppError(message: 'review.error_load', type: AppErrorType.server));
    }
  }

  Future<Either<AppError, List<ReviewModel>>> getMyReviews({int page = 1}) async {
    try {
      final res = await _service.getMyReviews(page: page);
      if (res.isSuccessful && res.body != null) {
        final raw = res.body!['items'] ?? res.body!['data'] ?? [];
        final list = raw is List ? raw : [];
        return Right(list.whereType<Map<String, dynamic>>().map(ReviewModel.fromJson).toList());
      }
      return Left(AppError.fromResponse(res.body, 'review.error_load'));
    } catch (_) {
      return Left(const AppError(message: 'review.error_load', type: AppErrorType.server));
    }
  }

  Future<Either<AppError, void>> createReview({
    required String orderId,
    required String restaurantId,
    required int restaurantRating,
    int? deliveryRating,
    String? comment,
  }) async {
    try {
      final res = await _service.createReview(
        orderId,
        restaurantId,
        restaurantRating,
        deliveryRating,
        comment,
      );
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'review.error_create'));
    } catch (_) {
      // Offline mode: queue the review
      await _pendingActionsDao.addPending('create_review', jsonEncode({
        'orderId': orderId,
        'restaurantId': restaurantId,
        'restaurantRating': restaurantRating,
        'deliveryRating': deliveryRating,
        'comment': comment,
      }));
      
      return const Right(null); // Return Right to signify that it will be handled
    }
  }
}

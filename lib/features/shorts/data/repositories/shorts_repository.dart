import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/shorts/data/datasources/shorts_service.dart';
import 'package:cliceat_app/features/shorts/data/models/video_review_model.dart';

@lazySingleton
class ShortsRepository {
  final ShortsService _shortsService;

  ShortsRepository(this._shortsService);

  Future<Either<AppError, List<VideoReviewModel>>> getFeed({
    String? city,
    int page = 1,
  }) async {
    try {
      final res = await _shortsService.getFeed(city: city, page: page);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'];
        List<dynamic> raw = [];
        if (data is List) {
          raw = data;
        } else if (data is Map<String, dynamic>) {
          raw = data['items'] as List<dynamic>? ?? [];
        }
        final videos = raw
            .whereType<Map<String, dynamic>>()
            .map(VideoReviewModel.fromJson)
            .toList();
        return Right(videos);
      }
      return Left(AppError.fromResponse(res.body, 'shorts.load_error',
          statusCode: res.statusCode));
    } catch (e, s) {
      debugPrint('[shorts_repository.dart] getFeed error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, VideoReviewModel>> uploadVideo(
    String orderId,
    List<int> videoBytes,
    String filename,
    int rating,
    String? caption,
  ) async {
    try {
      final res = await _shortsService.uploadShort(
        orderId,
        videoBytes,
        filename,
        rating,
        caption,
      );
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(VideoReviewModel.fromJson(data));
      }
      return Left(AppError.fromResponse(res.body, 'shorts.upload_error',
          statusCode: res.statusCode));
    } catch (e, s) {
      debugPrint('[shorts_repository.dart] uploadVideo error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> likeShort(String id) async {
    try {
      final res = await _shortsService.likeShort(id);
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'shorts.like_error',
          statusCode: res.statusCode));
    } catch (e, s) {
      debugPrint('[shorts_repository.dart] likeShort error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> incrementView(String id) async {
    try {
      final res = await _shortsService.incrementView(id);
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'shorts.view_error',
          statusCode: res.statusCode));
    } catch (e, s) {
      debugPrint('[shorts_repository.dart] incrementView error: $e\n$s');
      return Left(AppError.network());
    }
  }
}

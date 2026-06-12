import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_review_model.freezed.dart';
part 'video_review_model.g.dart';

@freezed
class VideoReviewModel with _$VideoReviewModel {
  const factory VideoReviewModel({
    required String id,
    required String orderId,
    required String videoUrl,
    String? thumbnailUrl,
    String? caption,
    required int rating,
    required String status,
    required int views,
    required int likesCount,
    required bool isLiked,
    Map<String, dynamic>? restaurant,
    Map<String, dynamic>? client,
    required DateTime createdAt,
  }) = _VideoReviewModel;

  factory VideoReviewModel.fromJson(Map<String, dynamic> json) =>
      _$VideoReviewModelFromJson(json);
}

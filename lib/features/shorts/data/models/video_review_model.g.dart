// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoReviewModel _$VideoReviewModelFromJson(Map<String, dynamic> json) =>
    _VideoReviewModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      rating: (json['rating'] as num).toInt(),
      status: json['status'] as String,
      views: (json['views'] as num).toInt(),
      likesCount: (json['likesCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      restaurant: json['restaurant'] as Map<String, dynamic>?,
      client: json['client'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VideoReviewModelToJson(_VideoReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'caption': instance.caption,
      'rating': instance.rating,
      'status': instance.status,
      'views': instance.views,
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
      'restaurant': instance.restaurant,
      'client': instance.client,
      'createdAt': instance.createdAt.toIso8601String(),
    };

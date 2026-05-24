// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'review_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ReviewService extends ReviewService {
  _$ReviewService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ReviewService;

  @override
  Future<Response<Map<String, dynamic>>> getRestaurantReviews(
    String restaurantId, {
    int page = 1,
    int limit = 20,
  }) {
    final Uri $url = Uri.parse('/reviews/restaurants/${restaurantId}/reviews');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getMyReviews({
    int page = 1,
    int limit = 20,
  }) {
    final Uri $url = Uri.parse('/reviews/my');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> createReview(
    String orderId,
    String restaurantId,
    int restaurantRating,
    int? deliveryRating,
    String? comment,
  ) {
    final Uri $url = Uri.parse('/reviews');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String>('orderId', orderId),
      PartValue<String>('restaurantId', restaurantId),
      PartValue<int>('restaurantRating', restaurantRating),
      PartValue<int?>('deliveryRating', deliveryRating),
      PartValue<String?>('comment', comment),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

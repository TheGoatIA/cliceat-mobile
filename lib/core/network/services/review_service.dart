import 'package:chopper/chopper.dart';

part 'review_service.chopper.dart';

/// Reviews endpoints — base: /reviews
/// Backend mount: app.use('/api/v1/reviews', reviewRoutes)
/// Routes inside: /restaurants/:id/reviews, /my, POST /
@ChopperApi(baseUrl: '/reviews')
abstract class ReviewService extends ChopperService {
  static ReviewService create([ChopperClient? client]) =>
      _$ReviewService(client);

  /// GET /reviews/restaurants/{id}/reviews
  @GET(path: '/restaurants/{id}/reviews')
  Future<Response<Map<String, dynamic>>> getRestaurantReviews(
    @Path('id') String restaurantId, {
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  /// GET /reviews/my
  @GET(path: '/my')
  Future<Response<Map<String, dynamic>>> getMyReviews({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  /// POST /reviews
  @POST()
  @multipart
  Future<Response<Map<String, dynamic>>> createReview(
    @Part('orderId') String orderId,
    @Part('restaurantId') String restaurantId,
    @Part('restaurantRating') int restaurantRating,
    @Part('deliveryRating') int? deliveryRating,
    @Part('comment') String? comment,
  );
}

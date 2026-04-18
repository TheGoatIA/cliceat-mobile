import 'package:chopper/chopper.dart';

part 'review_service.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class ReviewService extends ChopperService {
  static ReviewService create([ChopperClient? client]) =>
      _$ReviewService(client);

  @GET(path: '/restaurants/{id}/reviews')
  Future<Response<Map<String, dynamic>>> getRestaurantReviews(
    @Path('id') String restaurantId, {
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  @GET(path: '/reviews/my')
  Future<Response<Map<String, dynamic>>> getMyReviews({
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  @POST(path: '/reviews')
  @multipart
  Future<Response<Map<String, dynamic>>> createReview(
    @Part('orderId') String orderId,
    @Part('restaurantId') String restaurantId,
    @Part('restaurantRating') int restaurantRating,
    @Part('deliveryRating') int? deliveryRating,
    @Part('comment') String? comment,
  );
}

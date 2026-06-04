import 'package:chopper/chopper.dart';

part 'promotion_service.chopper.dart';

@ChopperApi(baseUrl: '/promotions')
abstract class PromotionService extends ChopperService {
  static PromotionService create([ChopperClient? client]) =>
      _$PromotionService(client);

  @GET(path: '/active')
  Future<Response<Map<String, dynamic>>> getActivePromotions();

  @GET(path: '/restaurant/{restaurantId}')
  Future<Response<Map<String, dynamic>>> getRestaurantPromotions(
    @Path('restaurantId') String restaurantId,
  );
}

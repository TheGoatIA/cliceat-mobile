import 'package:chopper/chopper.dart';

part 'restaurant_service.chopper.dart';

@ChopperApi(baseUrl: '/restaurants')
abstract class RestaurantService extends ChopperService {
  static RestaurantService create([ChopperClient? client]) =>
      _$RestaurantService(client);

  @GET()
  Future<Response> getRestaurants(
    @Query('city') String city,
    @Query('lat') double? lat,
    @Query('lng') double? lng,
    @Query('radius') int? radius,
    @Query('isOpen') bool? isOpen,
  );

  @GET(path: '/search')
  Future<Response> searchRestaurants(
    @Query('q') String query,
    @Query('city') String? city,
  );

  @GET(path: '/featured')
  Future<Response> getFeaturedRestaurants();

  @GET(path: '/{id}')
  Future<Response> getRestaurantDetails(@Path('id') String id);

  @GET(path: '/{id}/menu')
  Future<Response> getRestaurantMenu(@Path('id') String id);

  @GET(path: '/{id}/promotions')
  Future<Response> getRestaurantPromotions(@Path('id') String id);
}

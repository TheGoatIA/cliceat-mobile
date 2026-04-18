import 'package:chopper/chopper.dart';

part 'restaurant_service.chopper.dart';

@ChopperApi(baseUrl: '/restaurants')
abstract class RestaurantService extends ChopperService {
  static RestaurantService create([ChopperClient? client]) =>
      _$RestaurantService(client);

  @GET()
  Future<Response> getRestaurants(
    @Query('city') String city,
    @Query('radius') double? radius,
    @Query('lat') double? lat,
    @Query('lng') double? lng,
  );

  @GET(path: '/featured')
  Future<Response> getFeaturedRestaurants();

  @GET(path: '/search')
  Future<Response> searchRestaurants(@Query('q') String query);

  @GET(path: '/{id}')
  Future<Response> getRestaurantDetails(@Path('id') String id);

  @GET(path: '/{id}/menu')
  Future<Response> getRestaurantMenu(@Path('id') String id);

  @POST(path: '/{id}/favorite')
  Future<Response> toggleFavorite(@Path('id') String id);
}

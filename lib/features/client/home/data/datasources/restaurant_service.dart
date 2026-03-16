import 'package:chopper/chopper.dart';

part 'restaurant_service.chopper.dart';

@ChopperApi(baseUrl: '/restaurants')
abstract class RestaurantService extends ChopperService {
  static RestaurantService create([ChopperClient? client]) => _$RestaurantService(client);

  @GET()
  Future<Response> getRestaurants(
    @Query('city') String city,
    @Query('lat') double? lat,
    @Query('lng') double? lng,
  );

  @GET(path: '/{id}')
  Future<Response> getRestaurantDetails(@Path('id') String id);

  @GET(path: '/{id}/menu')
  Future<Response> getRestaurantMenu(@Path('id') String id);
}

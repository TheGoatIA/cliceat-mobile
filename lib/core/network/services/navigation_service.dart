import 'package:chopper/chopper.dart';

part 'navigation_service.chopper.dart';

@ChopperApi(baseUrl: '/navigation')
abstract class NavigationService extends ChopperService {
  static NavigationService create([ChopperClient? client]) => _$NavigationService(client);

  @POST(path: '/route')
  Future<Response<Map<String, dynamic>>> computeRoute(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/reroute')
  Future<Response<Map<String, dynamic>>> reroute(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/eta/{orderId}')
  Future<Response<Map<String, dynamic>>> getOrderETA(
    @Path('orderId') String orderId,
  );

  @GET(path: '/traffic')
  Future<Response<Map<String, dynamic>>> getTrafficZones({
    @Query('city') String? city,
  });
}

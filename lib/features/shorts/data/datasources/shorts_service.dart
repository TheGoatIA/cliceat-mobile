import 'package:chopper/chopper.dart';

part 'shorts_service.chopper.dart';

@ChopperApi(baseUrl: '/shorts')
abstract class ShortsService extends ChopperService {
  static ShortsService create([ChopperClient? client]) =>
      _$ShortsService(client);

  @GET(path: '/feed')
  Future<Response<Map<String, dynamic>>> getFeed({
    @Query('city') String? city,
    @Query('page') int page = 1,
  });

  @POST(path: '/upload')
  @multipart
  Future<Response<Map<String, dynamic>>> uploadShort(
    @Part('orderId') String orderId,
    @PartFile('video') List<int> videoBytes,
    @Part('filename') String filename,
    @Part('rating') int rating,
    @Part('caption') String? caption,
  );

  @POST(path: '/{id}/like')
  Future<Response<Map<String, dynamic>>> likeShort(
    @Path('id') String id,
  );

  @POST(path: '/{id}/view')
  Future<Response<Map<String, dynamic>>> incrementView(
    @Path('id') String id,
  );
}

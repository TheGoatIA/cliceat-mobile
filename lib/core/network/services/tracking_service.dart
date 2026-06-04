import 'package:chopper/chopper.dart';

part 'tracking_service.chopper.dart';

@ChopperApi(baseUrl: '/tracking')
abstract class TrackingService extends ChopperService {
  static TrackingService create([ChopperClient? client]) =>
      _$TrackingService(client);

  /// GET /tracking/{orderId}
  @GET(path: '/{orderId}')
  Future<Response<Map<String, dynamic>>> getTracking(
    @Path('orderId') String orderId,
  );

  /// GET /tracking/{orderId}/eta
  @GET(path: '/{orderId}/eta')
  Future<Response<Map<String, dynamic>>> getEta(
    @Path('orderId') String orderId,
  );
}

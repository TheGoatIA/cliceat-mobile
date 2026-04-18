import 'package:chopper/chopper.dart';

part 'tracking_service.chopper.dart';

@ChopperApi(baseUrl: '/tracking')
abstract class TrackingService extends ChopperService {
  static TrackingService create([ChopperClient? client]) =>
      _$TrackingService(client);

  @GET(path: '/{orderId}')
  Future<Response> getTracking(@Path('orderId') String orderId);

  @GET(path: '/{orderId}/eta')
  Future<Response> getEta(@Path('orderId') String orderId);
}

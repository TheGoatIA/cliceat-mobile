import 'package:chopper/chopper.dart';

part 'mission_service.chopper.dart';

@ChopperApi(baseUrl: '/missions')
abstract class MissionService extends ChopperService {
  static MissionService create([ChopperClient? client]) => _$MissionService(client);

  @GET()
  Future<Response<Map<String, dynamic>>> getActiveMissions();

  @PATCH(path: '/{id}/accept')
  Future<Response<Map<String, dynamic>>> acceptMission(@Path('id') String id);

  @PATCH(path: '/{id}/reject')
  Future<Response<Map<String, dynamic>>> rejectMission(@Path('id') String id);

  @PATCH(path: '/{id}/status')
  Future<Response<Map<String, dynamic>>> updateMissionStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/{id}/report')
  Future<Response<Map<String, dynamic>>> reportMission(
    @Path('id') String id,
    @Body() Map<String, dynamic> reportData,
  );
}

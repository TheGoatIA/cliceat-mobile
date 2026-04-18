import 'package:chopper/chopper.dart';

part 'ai_service.chopper.dart';

@ChopperApi(baseUrl: '/ai')
abstract class AiService extends ChopperService {
  static AiService create([ChopperClient? client]) => _$AiService(client);

  @POST(path: '/chat')
  Future<Response<Map<String, dynamic>>> sendMessage(
      @Body() Map<String, dynamic> body);

  @GET(path: '/suggestions')
  Future<Response<Map<String, dynamic>>> getSuggestions(
      {@Query('city') String? city});
}

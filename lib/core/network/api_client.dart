import 'package:chopper/chopper.dart';

part 'api_client.chopper.dart';

@ChopperApi()
abstract class ApiClient extends ChopperService {
  static ApiClient create([ChopperClient? client]) => _$ApiClient(client);
}



import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env_config.dart';
import 'interceptors/auth_interceptor.dart';
import '../../features/auth/data/datasources/auth_service.dart';
import '../../features/client/home/data/datasources/restaurant_service.dart';
import 'services/delivery_service.dart';
import 'services/order_service.dart';

part 'api_client.chopper.dart';

@ChopperApi()
abstract class ApiClient extends ChopperService {
  static ApiClient create([ChopperClient? client]) => _$ApiClient(client);
}

ChopperClient buildChopperClient() {
  return ChopperClient(
    baseUrl: Uri.parse(EnvConfig.apiBaseUrl),
    services: [
      AuthService.create(),
      RestaurantService.create(),
      DeliveryService.create(),
      OrderService.create(),
    ],
    converter: const JsonConverter(),
    interceptors: [
      HttpLoggingInterceptor(),
      AuthInterceptor(const FlutterSecureStorage()),
    ],
  );
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/auth/data/datasources/auth_service.dart';
import '../../features/client/home/data/datasources/restaurant_service.dart';
import '../network/services/delivery_service.dart';
import '../network/services/order_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  final chopperClient = buildChopperClient();

  getIt.registerSingleton(chopperClient);
  getIt.registerSingleton<AuthService>(
    chopperClient.getService<AuthService>(),
  );
  getIt.registerSingleton<RestaurantService>(
    chopperClient.getService<RestaurantService>(),
  );
  getIt.registerSingleton<DeliveryService>(
    chopperClient.getService<DeliveryService>(),
  );
  getIt.registerSingleton<OrderService>(
    chopperClient.getService<OrderService>(),
  );
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );
}

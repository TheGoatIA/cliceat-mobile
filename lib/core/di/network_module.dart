import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/refresh_interceptor.dart';
import '../network/interceptors/connectivity_interceptor.dart';
import '../config/env_config.dart';
import '../../features/auth/data/datasources/auth_service.dart';
import '../../features/client/home/data/datasources/restaurant_service.dart';
import '../../features/client/cart/data/datasources/order_service.dart';
import '../../features/client/cart/data/datasources/payment_service.dart';
import '../../features/delivery/dashboard/data/datasources/mission_service.dart';
import '../../features/delivery/dashboard/data/datasources/driver_service.dart';
import '../di/injection.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  ChopperClient chopperClient(FlutterSecureStorage secureStorage) {
    // We pass a lazy getter for the AuthService into the RefreshInterceptor 
    return ChopperClient(
      baseUrl: Uri.parse(EnvConfig.apiBaseUrl),
      services: [
        AuthService.create(),
        RestaurantService.create(),
        OrderService.create(),
        PaymentService.create(),
        MissionService.create(),
        DriverService.create(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
        ConnectivityInterceptor(),
        AuthInterceptor(secureStorage),
        RefreshInterceptor(secureStorage, () => getIt<AuthService>().refreshToken()),
      ],
    );
  }

  @lazySingleton
  AuthService getAuthService(ChopperClient client) => client.getService<AuthService>();

  @lazySingleton
  RestaurantService getRestaurantService(ChopperClient client) => client.getService<RestaurantService>();

  @lazySingleton
  OrderService getOrderService(ChopperClient client) => client.getService<OrderService>();

  @lazySingleton
  PaymentService getPaymentService(ChopperClient client) => client.getService<PaymentService>();
  
  @lazySingleton
  MissionService getMissionService(ChopperClient client) => client.getService<MissionService>();

  @lazySingleton
  DriverService getDriverService(ChopperClient client) => client.getService<DriverService>();
}

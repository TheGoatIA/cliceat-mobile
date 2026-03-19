import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/refresh_interceptor.dart';
import '../network/interceptors/connectivity_interceptor.dart';
import '../network/interceptors/retry_interceptor.dart';
import '../network/interceptors/timeout_interceptor.dart';
import '../config/env_config.dart';
import '../../features/auth/data/datasources/auth_service.dart';
import '../../features/client/home/data/datasources/restaurant_service.dart';
import '../../features/client/cart/data/datasources/order_service.dart';
import '../../features/client/cart/data/datasources/payment_service.dart';
import '../../features/delivery/dashboard/data/datasources/mission_service.dart';
import '../../features/delivery/dashboard/data/datasources/driver_service.dart';
import '../network/services/user_service.dart';
import '../network/services/tracking_service.dart';
import '../network/services/coupon_service.dart';
import '../di/injection.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  ChopperClient chopperClient(FlutterSecureStorage secureStorage) {
    // Configurer le client HTTP avec un timeout de connexion adapté
    // aux réseaux 3G/4G camerounais (15s de connexion).
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    final ioClient = IOClient(httpClient);

    return ChopperClient(
      baseUrl: Uri.parse(EnvConfig.apiBaseUrl),
      client: ioClient,
      services: [
        AuthService.create(),
        RestaurantService.create(),
        OrderService.create(),
        PaymentService.create(),
        MissionService.create(),
        DriverService.create(),
        UserService.create(),
        TrackingService.create(),
        CouponService.create(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        // 🔴 SÉCURITÉ : Logger uniquement en mode debug.
        // En production, le body HTTP ne doit JAMAIS apparaître dans les logs
        // (tokens JWT, mots de passe, données bancaires → violation RGPD).
        if (kDebugMode) HttpLoggingInterceptor(),

        // Timeout receive : 30s (adapté aux latences 3G camerounaises)
        const TimeoutInterceptor(receiveTimeout: Duration(seconds: 30)),

        // Retry automatique : max 3 tentatives, backoff 1s → 2s → 4s
        RetryInterceptor(maxRetries: 3),

        // Vérification connectivité avant la requête
        ConnectivityInterceptor(),

        // Injection du token JWT Bearer
        AuthInterceptor(secureStorage),

        // Refresh automatique sur 401 avec mutex (voir refresh_interceptor.dart)
        RefreshInterceptor(
          secureStorage,
          () => getIt<AuthService>().refreshToken(),
        ),
      ],
    );
  }

  @lazySingleton
  AuthService getAuthService(ChopperClient client) =>
      client.getService<AuthService>();

  @lazySingleton
  RestaurantService getRestaurantService(ChopperClient client) =>
      client.getService<RestaurantService>();

  @lazySingleton
  OrderService getOrderService(ChopperClient client) =>
      client.getService<OrderService>();

  @lazySingleton
  PaymentService getPaymentService(ChopperClient client) =>
      client.getService<PaymentService>();

  @lazySingleton
  MissionService getMissionService(ChopperClient client) =>
      client.getService<MissionService>();

  @lazySingleton
  DriverService getDriverService(ChopperClient client) =>
      client.getService<DriverService>();

  @lazySingleton
  UserService getUserService(ChopperClient client) =>
      client.getService<UserService>();

  @lazySingleton
  TrackingService getTrackingService(ChopperClient client) =>
      client.getService<TrackingService>();

  @lazySingleton
  CouponService getCouponService(ChopperClient client) =>
      client.getService<CouponService>();
}

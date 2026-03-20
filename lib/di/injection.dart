import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

// Repositories & services registered without code generation
import 'package:cliceat_app/features/auth/data/repositories/auth_repository.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';
import 'package:cliceat_app/features/client/home/data/repositories/restaurant_repository.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/driver_repository.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/coupon_repository.dart';
import 'package:cliceat_app/core/services/analytics_service.dart';
import 'package:cliceat_app/core/data/local/daos/cart_dao.dart';
import 'package:cliceat_app/core/data/local/daos/restaurant_dao.dart';
import 'package:cliceat_app/core/data/local/daos/user_prefs_dao.dart';
import 'package:cliceat_app/core/data/local/database.dart';
import 'package:cliceat_app/core/network/services/user_service.dart';
import 'package:cliceat_app/core/network/services/coupon_service.dart';
import 'package:cliceat_app/core/../features/auth/data/datasources/auth_service.dart';
import 'package:cliceat_app/core/../features/client/cart/data/datasources/order_service.dart';
import 'package:cliceat_app/core/../features/client/cart/data/datasources/payment_service.dart';
import 'package:cliceat_app/core/network/services/tracking_service.dart';
import 'package:cliceat_app/core/../features/client/home/data/datasources/restaurant_service.dart';
import 'package:cliceat_app/core/../features/delivery/dashboard/data/datasources/mission_service.dart';
import 'package:cliceat_app/core/../features/delivery/dashboard/data/datasources/driver_service.dart';
import 'package:cliceat_app/core/../features/client/cart/presentation/bloc/cart_cubit.dart';
import 'package:cliceat_app/core/../features/client/cart/presentation/bloc/order_bloc.dart';
import 'package:cliceat_app/core/../features/delivery/dashboard/presentation/bloc/mission_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();
  _registerDaos();
  _registerRepositories();
  _registerAnalytics();
  _registerMigratedBlocs();
}

void _registerDaos() {
  getIt.registerLazySingleton<CartDao>(
    () => CartDao(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<RestaurantDao>(
    () => RestaurantDao(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<UserPrefsDao>(
    () => UserPrefsDao(getIt<AppDatabase>()),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<AuthService>(),
      getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepository(
      getIt<OrderService>(),
      getIt<PaymentService>(),
      getIt<TrackingService>(),
    ),
  );
  getIt.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepository(
      getIt<RestaurantService>(),
      getIt<RestaurantDao>(),
    ),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<UserService>()),
  );
  getIt.registerLazySingleton<DriverRepository>(
    () => DriverRepository(
      getIt<MissionService>(),
      getIt<DriverService>(),
    ),
  );
  getIt.registerLazySingleton<CouponRepository>(
    () => CouponRepository(getIt<CouponService>()),
  );
}

void _registerAnalytics() {
  getIt.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(getIt<Logger>()),
  );
}

/// BLoCs that were migrated off @injectable (constructor now takes repositories).
void _registerMigratedBlocs() {
  // CartCubit : factory (une instance par page qui l'utilise, ou singleton
  // injecté via BlocProvider dans main.dart). Ici factory pour la flexibilité.
  getIt.registerFactory<CartCubit>(
    () => CartCubit(getIt<AppDatabase>()),
  );
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(getIt<OrderRepository>()),
  );
  getIt.registerFactory<MissionBloc>(
    () => MissionBloc(getIt<DriverRepository>()),
  );
}


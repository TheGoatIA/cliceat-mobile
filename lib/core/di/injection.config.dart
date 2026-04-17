// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i31;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../../features/auth/data/datasources/auth_service.dart' as _i1060;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/client/cart/data/datasources/order_service.dart'
    as _i271;
import '../../features/client/cart/data/datasources/payment_service.dart'
    as _i816;
import '../../features/client/cart/data/repositories/coupon_repository.dart'
    as _i863;
import '../../features/client/cart/data/repositories/order_repository.dart'
    as _i1060;
import '../../features/client/cart/presentation/bloc/cart_cubit.dart' as _i308;
import '../../features/client/cart/presentation/bloc/order_bloc.dart' as _i438;
import '../../features/client/home/data/datasources/restaurant_service.dart'
    as _i813;
import '../../features/client/home/data/repositories/restaurant_repository.dart'
    as _i1001;
import '../../features/client/profile/data/repositories/user_repository.dart'
    as _i482;
import '../../features/delivery/dashboard/data/datasources/driver_service.dart'
    as _i170;
import '../../features/delivery/dashboard/data/datasources/mission_service.dart'
    as _i304;
import '../../features/delivery/dashboard/data/repositories/driver_repository.dart'
    as _i530;
import '../../features/delivery/dashboard/presentation/bloc/mission_bloc.dart'
    as _i203;
import '../data/local/daos/cart_dao.dart' as _i322;
import '../data/local/daos/restaurant_dao.dart' as _i471;
import '../data/local/daos/user_prefs_dao.dart' as _i658;
import '../data/local/database.dart' as _i475;
import '../network/services/coupon_service.dart' as _i851;
import '../network/services/tracking_service.dart' as _i930;
import '../network/services/user_service.dart' as _i895;
import '../services/analytics_service.dart' as _i222;
import '../services/deep_link_service.dart' as _i391;
import '../services/location_service.dart' as _i669;
import '../services/notification_service.dart' as _i941;
import '../services/websocket_service.dart' as _i555;
import 'core_module.dart' as _i154;
import 'network_module.dart' as _i567;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i974.Logger>(() => coreModule.logger);
    gh.lazySingleton<_i475.AppDatabase>(() => coreModule.database);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => coreModule.secureStorage,
    );
    gh.lazySingleton<_i669.LocationService>(() => _i669.LocationService());
    gh.factory<_i308.CartCubit>(() => _i308.CartCubit(gh<_i475.AppDatabase>()));
    gh.lazySingleton<_i322.CartDao>(
      () => _i322.CartDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i471.RestaurantDao>(
      () => _i471.RestaurantDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i658.UserPrefsDao>(
      () => _i658.UserPrefsDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i222.AnalyticsService>(
      () => _i222.AnalyticsService(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i391.DeepLinkService>(
      () => _i391.DeepLinkService(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i941.NotificationService>(
      () => _i941.NotificationService(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i31.ChopperClient>(
      () => networkModule.chopperClient(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i555.WebSocketService>(
      () => _i555.WebSocketService(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i1060.AuthService>(
      () => networkModule.getAuthService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i813.RestaurantService>(
      () => networkModule.getRestaurantService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i271.OrderService>(
      () => networkModule.getOrderService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i816.PaymentService>(
      () => networkModule.getPaymentService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i304.MissionService>(
      () => networkModule.getMissionService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i170.DriverService>(
      () => networkModule.getDriverService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i895.UserService>(
      () => networkModule.getUserService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i851.CouponService>(
      () => networkModule.getCouponService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i930.TrackingService>(
      () => networkModule.getTrackingService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i863.CouponRepository>(
      () => _i863.CouponRepository(gh<_i851.CouponService>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i1060.AuthService>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i475.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i1060.OrderRepository>(
      () => _i1060.OrderRepository(
        gh<_i271.OrderService>(),
        gh<_i816.PaymentService>(),
        gh<_i930.TrackingService>(),
      ),
    );
    gh.lazySingleton<_i573.AuthRepository>(
      () => _i573.AuthRepository(
        gh<_i1060.AuthService>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i530.DriverRepository>(
      () => _i530.DriverRepository(
        gh<_i304.MissionService>(),
        gh<_i170.DriverService>(),
      ),
    );
    gh.lazySingleton<_i482.UserRepository>(
      () => _i482.UserRepository(gh<_i895.UserService>()),
    );
    gh.factory<_i438.OrderBloc>(
      () => _i438.OrderBloc(gh<_i1060.OrderRepository>()),
    );
    gh.lazySingleton<_i1001.RestaurantRepository>(
      () => _i1001.RestaurantRepository(
        gh<_i813.RestaurantService>(),
        gh<_i471.RestaurantDao>(),
      ),
    );
    gh.factory<_i203.MissionBloc>(
      () => _i203.MissionBloc(gh<_i530.DriverRepository>()),
    );
    return this;
  }
}

class _$CoreModule extends _i154.CoreModule {}

class _$NetworkModule extends _i567.NetworkModule {}

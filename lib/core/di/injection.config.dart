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

import '../../features/auth/data/datasources/auth_service.dart' as _i1060;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/client/cart/data/datasources/order_service.dart'
    as _i271;
import '../../features/client/cart/data/datasources/payment_service.dart'
    as _i816;
import '../../features/client/cart/presentation/bloc/order_bloc.dart' as _i438;
import '../../features/client/home/data/datasources/restaurant_service.dart'
    as _i813;
import '../../features/delivery/dashboard/data/datasources/driver_service.dart'
    as _i170;
import '../../features/delivery/dashboard/data/datasources/mission_service.dart'
    as _i304;
import '../../features/delivery/dashboard/presentation/bloc/mission_bloc.dart'
    as _i203;
import '../data/local/database.dart' as _i475;
import 'network_module.dart' as _i567;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i31.ChopperClient>(
      () => networkModule.chopperClient(gh<_i558.FlutterSecureStorage>()),
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
    gh.factory<_i203.MissionBloc>(
      () => _i203.MissionBloc(gh<_i304.MissionService>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i1060.AuthService>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i475.AppDatabase>(),
      ),
    );
    gh.factory<_i438.OrderBloc>(
      () => _i438.OrderBloc(gh<_i271.OrderService>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}

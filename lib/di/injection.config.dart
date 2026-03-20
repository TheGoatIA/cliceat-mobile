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

import '../core/data/local/database.dart' as _i44;
import '../core/network/services/coupon_service.dart' as _i733;
import '../core/network/services/tracking_service.dart' as _i437;
import '../core/network/services/user_service.dart' as _i50;
import '../features/auth/data/datasources/auth_service.dart' as _i191;
import '../features/auth/presentation/bloc/auth_bloc.dart' as _i59;
import '../features/client/cart/data/datasources/order_service.dart' as _i554;
import '../features/client/cart/data/datasources/payment_service.dart' as _i216;
import '../features/client/home/data/datasources/restaurant_service.dart'
    as _i167;
import '../features/delivery/dashboard/data/datasources/driver_service.dart'
    as _i713;
import '../features/delivery/dashboard/data/datasources/mission_service.dart'
    as _i60;
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
    gh.lazySingleton<_i191.AuthService>(
      () => networkModule.getAuthService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i167.RestaurantService>(
      () => networkModule.getRestaurantService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i554.OrderService>(
      () => networkModule.getOrderService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i216.PaymentService>(
      () => networkModule.getPaymentService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i60.MissionService>(
      () => networkModule.getMissionService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i713.DriverService>(
      () => networkModule.getDriverService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i50.UserService>(
      () => networkModule.getUserService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i437.TrackingService>(
      () => networkModule.getTrackingService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i733.CouponService>(
      () => networkModule.getCouponService(gh<_i31.ChopperClient>()),
    );
    gh.factory<_i59.AuthBloc>(
      () => _i59.AuthBloc(
        gh<_i191.AuthService>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i44.AppDatabase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}

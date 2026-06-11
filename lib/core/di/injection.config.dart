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
import '../../features/chat/data/datasources/chat_service.dart' as _i321;
import '../../features/chat/data/repositories/chat_repository.dart' as _i796;
import '../../features/chat/presentation/cubit/chat_cubit.dart' as _i305;
import '../../features/client/ai/data/repositories/ai_repository.dart' as _i48;
import '../../features/client/ai/data/local/ai_dao.dart' as _i91;
import '../../features/client/ai/presentation/cubit/ai_cubit.dart' as _i585;
import '../../features/client/banner/data/repositories/banner_repository.dart'
    as _i359;
import '../../features/client/banner/presentation/cubit/banner_cubit.dart'
    as _i28;
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
import '../../features/client/dispute/data/datasources/dispute_service.dart'
    as _i214;
import '../../features/client/dispute/data/repositories/dispute_repository.dart'
    as _i136;
import '../../features/client/dispute/presentation/bloc/dispute_cubit.dart'
    as _i24;
import '../../features/client/home/data/datasources/promotion_service.dart'
    as _i996;
import '../../features/client/home/data/datasources/restaurant_service.dart'
    as _i813;
import '../../features/client/home/data/repositories/promotion_repository.dart'
    as _i241;
import '../../features/client/home/data/repositories/restaurant_repository.dart'
    as _i1001;
import '../../features/client/home/presentation/bloc/home_cubit.dart'
    as _i999;
import '../../features/client/home/presentation/bloc/promotion_cubit.dart'
    as _i340;
import '../../features/client/notification/data/repositories/notification_repository.dart'
    as _i953;
import '../../features/client/notification/presentation/cubit/notification_cubit.dart'
    as _i117;
import '../../features/client/profile/data/repositories/user_repository.dart'
    as _i482;
import '../../features/client/profile/presentation/bloc/profile_cubit.dart'
    as _i747;
import '../../features/client/referral/data/repositories/referral_repository.dart'
    as _i1030;
import '../../features/client/referral/presentation/cubit/referral_cubit.dart'
    as _i892;
import '../../features/client/review/data/repositories/review_repository.dart'
    as _i656;
import '../../features/client/review/presentation/cubit/review_cubit.dart'
    as _i787;
import '../../features/client/wallet/data/datasources/wallet_service.dart'
    as _i667;
import '../../features/client/wallet/data/repositories/wallet_repository.dart'
    as _i691;
import '../../features/client/wallet/presentation/bloc/wallet_cubit.dart'
    as _i341;
import '../../features/delivery/dashboard/data/datasources/driver_service.dart'
    as _i170;
import '../../features/delivery/dashboard/data/datasources/mission_service.dart'
    as _i304;
import '../../features/delivery/dashboard/data/datasources/payout_service.dart'
    as _i580;
import '../../features/delivery/dashboard/data/repositories/driver_repository.dart'
    as _i530;
import '../../features/delivery/dashboard/data/repositories/payout_repository.dart'
    as _i964;
import '../../features/delivery/dashboard/presentation/bloc/mission_bloc.dart'
    as _i203;
import '../../features/delivery/dashboard/presentation/bloc/payout_cubit.dart'
    as _i704;
import '../config/presentation/bloc/config_bloc.dart' as _i787;
import '../data/local/daos/cart_dao.dart' as _i322;
import '../data/local/daos/chat_dao.dart' as _i468;
import '../data/local/daos/favorites_dao.dart' as _i968;
import '../data/local/daos/menu_dao.dart' as _i594;
import '../data/local/daos/order_dao.dart' as _i427;
import '../data/local/daos/offline_queue_dao.dart' as _i633;
import '../data/local/daos/pending_actions_dao.dart' as _i902;
import '../data/local/daos/restaurant_dao.dart' as _i471;
import '../data/local/daos/user_prefs_dao.dart' as _i658;
import '../data/local/database.dart' as _i475;
import '../network/repositories/platform_repository.dart' as _i173;
import '../network/services/ai_service.dart' as _i176;
import '../network/services/coupon_service.dart' as _i851;
import '../network/services/platform_service.dart' as _i525;
import '../network/services/referral_service.dart' as _i596;
import '../network/services/review_service.dart' as _i289;
import '../network/services/tracking_service.dart' as _i930;
import '../network/services/user_service.dart' as _i895;
import '../services/analytics_service.dart' as _i222;
import '../services/deep_link_service.dart' as _i391;
import '../services/device_service.dart' as _i738;
import '../services/location_service.dart' as _i669;
import '../services/notification_service.dart' as _i941;
import '../services/precache_service.dart' as _i1048;
import '../services/sync_manager_service.dart' as _i114;
import '../services/token_service.dart' as _i227;
import '../services/websocket_service.dart' as _i555;
import '../theme/presentation/bloc/theme_cubit.dart' as _i787;
import 'core_module.dart' as _i154;
import 'network_module.dart' as _i567;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreModule = _$CoreModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i974.Logger>(() => coreModule.logger);
    gh.lazySingleton<_i475.AppDatabase>(() => coreModule.database);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => coreModule.secureStorage,
    );
    gh.lazySingleton<_i738.DeviceService>(() => _i738.DeviceService());
    gh.lazySingleton<_i669.LocationService>(() => _i669.LocationService());
    gh.lazySingleton<_i322.CartDao>(
      () => _i322.CartDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i968.FavoritesDao>(
      () => _i968.FavoritesDao(gh<_i475.AppDatabase>()),
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
    gh.lazySingleton<_i1048.PrecacheService>(
      () => _i1048.PrecacheService(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i427.OrderDao>(
      () => _i427.OrderDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i227.TokenService>(
      () => _i227.TokenService(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i468.ChatDao>(
      () => _i468.ChatDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i594.MenuDao>(
      () => _i594.MenuDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i902.PendingActionsDao>(
      () => _i902.PendingActionsDao(gh<_i475.AppDatabase>()),
    );
    gh.lazySingleton<_i633.OfflineQueueDao>(
      () => _i633.OfflineQueueDao(gh<_i475.AppDatabase>()),
    );
    await gh.lazySingletonAsync<_i31.ChopperClient>(
      () => networkModule.chopperClient(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i227.TokenService>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i787.ThemeCubit>(
      () =>
          _i787.ThemeCubit(gh<_i658.UserPrefsDao>(), gh<_i227.TokenService>()),
    );
    gh.lazySingleton<_i555.WebSocketService>(
      () =>
          _i555.WebSocketService(gh<_i227.TokenService>(), gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i308.CartCubit>(
      () => _i308.CartCubit(
        gh<_i475.AppDatabase>(),
        gh<_i222.AnalyticsService>(),
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
    gh.lazySingleton<_i596.ReferralService>(
      () => networkModule.getReferralService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i176.AiService>(
      () => networkModule.getAiService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i289.ReviewService>(
      () => networkModule.getReviewService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i525.PlatformService>(
      () => networkModule.getPlatformService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i321.ChatService>(
      () => networkModule.getChatService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i667.WalletService>(
      () => networkModule.getWalletService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i214.DisputeService>(
      () => networkModule.getDisputeService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i996.PromotionService>(
      () => networkModule.getPromotionService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i580.PayoutService>(
      () => networkModule.getPayoutService(gh<_i31.ChopperClient>()),
    );
    gh.lazySingleton<_i91.AiLocalDao>(
      () => _i91.AiLocalDao(gh<_i475.AppDatabase>()),
    );
    gh.factory<_i48.AiRepository>(
      () => _i48.AiRepository(gh<_i176.AiService>(), gh<_i91.AiLocalDao>()),
    );
    gh.lazySingleton<_i863.CouponRepository>(
      () => _i863.CouponRepository(gh<_i851.CouponService>()),
    );
    gh.lazySingleton<_i114.SyncManagerService>(
      () => _i114.SyncManagerService(
        gh<_i902.PendingActionsDao>(),
        gh<_i633.OfflineQueueDao>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i1060.OrderRepository>(
      () => _i1060.OrderRepository(
        gh<_i271.OrderService>(),
        gh<_i816.PaymentService>(),
        gh<_i667.WalletService>(),
        gh<_i930.TrackingService>(),
        gh<_i427.OrderDao>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i1030.ReferralRepository>(
      () => _i1030.ReferralRepository(gh<_i596.ReferralService>()),
    );
    gh.factory<_i892.ReferralCubit>(
      () => _i892.ReferralCubit(gh<_i1030.ReferralRepository>()),
    );
    gh.lazySingleton<_i241.PromotionRepository>(
      () => _i241.PromotionRepository(gh<_i996.PromotionService>()),
    );
    gh.lazySingleton<_i530.DriverRepository>(
      () => _i530.DriverRepository(
        gh<_i304.MissionService>(),
        gh<_i170.DriverService>(),
      ),
    );
    gh.lazySingleton<_i964.PayoutRepository>(
      () => _i964.PayoutRepository(gh<_i580.PayoutService>()),
    );
    gh.factory<_i796.ChatRepository>(
      () => _i796.ChatRepository(
        gh<_i321.ChatService>(),
        gh<_i468.ChatDao>(),
        gh<_i902.PendingActionsDao>(),
      ),
    );
    gh.lazySingleton<_i136.DisputeRepository>(
      () => _i136.DisputeRepository(gh<_i214.DisputeService>()),
    );
    gh.factory<_i359.BannerRepository>(
      () => _i359.BannerRepository(gh<_i525.PlatformService>()),
    );
    gh.lazySingleton<_i173.PlatformRepository>(
      () => _i173.PlatformRepository(gh<_i525.PlatformService>()),
    );
    gh.lazySingleton<_i573.AuthRepository>(
      () => _i573.AuthRepository(
        gh<_i1060.AuthService>(),
        gh<_i895.UserService>(),
        gh<_i941.NotificationService>(),
        gh<_i738.DeviceService>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i656.ReviewRepository>(
      () => _i656.ReviewRepository(
        gh<_i289.ReviewService>(),
        gh<_i902.PendingActionsDao>(),
      ),
    );
    gh.lazySingleton<_i482.UserRepository>(
      () => _i482.UserRepository(
        gh<_i895.UserService>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i28.BannerCubit>(
      () => _i28.BannerCubit(gh<_i359.BannerRepository>()),
    );
    gh.factory<_i585.AiCubit>(() => _i585.AiCubit(gh<_i48.AiRepository>()));
    gh.lazySingleton<_i953.NotificationRepository>(
      () => _i953.NotificationRepository(gh<_i895.UserService>()),
    );
    gh.factory<_i787.ReviewCubit>(
      () => _i787.ReviewCubit(gh<_i656.ReviewRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i1060.AuthService>(),
        gh<_i170.DriverService>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i475.AppDatabase>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.lazySingleton<_i691.WalletRepository>(
      () => _i691.WalletRepository(
        gh<_i667.WalletService>(),
        gh<_i816.PaymentService>(),
      ),
    );
    gh.factory<_i340.PromotionCubit>(
      () => _i340.PromotionCubit(gh<_i241.PromotionRepository>()),
    );
    gh.factory<_i999.HomeCubit>(() => _i999.HomeCubit());
    gh.lazySingleton<_i1001.RestaurantRepository>(
      () => _i1001.RestaurantRepository(
        gh<_i813.RestaurantService>(),
        gh<_i471.RestaurantDao>(),
        gh<_i594.MenuDao>(),
      ),
    );
    gh.factory<_i438.OrderBloc>(
      () => _i438.OrderBloc(
        gh<_i1060.OrderRepository>(),
        gh<_i555.WebSocketService>(),
      ),
    );
    gh.lazySingleton<_i747.ProfileCubit>(
      () => _i747.ProfileCubit(gh<_i482.UserRepository>()),
    );
    gh.factory<_i305.ChatCubit>(
      () => _i305.ChatCubit(gh<_i796.ChatRepository>()),
    );
    gh.lazySingleton<_i787.ConfigBloc>(
      () => _i787.ConfigBloc(gh<_i173.PlatformRepository>()),
    );
    gh.factory<_i24.DisputeCubit>(
      () => _i24.DisputeCubit(gh<_i136.DisputeRepository>()),
    );
    gh.factory<_i203.MissionBloc>(
      () => _i203.MissionBloc(gh<_i530.DriverRepository>()),
    );
    gh.factory<_i704.PayoutCubit>(
      () => _i704.PayoutCubit(gh<_i964.PayoutRepository>()),
    );
    gh.factory<_i117.NotificationCubit>(
      () => _i117.NotificationCubit(gh<_i953.NotificationRepository>()),
    );
    gh.factory<_i341.WalletCubit>(
      () => _i341.WalletCubit(gh<_i691.WalletRepository>()),
    );
    return this;
  }
}

class _$CoreModule extends _i154.CoreModule {}

class _$NetworkModule extends _i567.NetworkModule {}

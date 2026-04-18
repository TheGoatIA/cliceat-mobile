import 'package:injectable/injectable.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/refresh_interceptor.dart';
import '../network/interceptors/connectivity_interceptor.dart';
import '../network/interceptors/retry_interceptor.dart';
import '../network/interceptors/timeout_interceptor.dart';
import '../services/token_service.dart';
import '../config/env_config.dart';
import '../../features/auth/data/datasources/auth_service.dart';
import '../../features/client/home/data/datasources/restaurant_service.dart';
import '../../features/client/cart/data/datasources/order_service.dart';
import '../../features/client/cart/data/datasources/payment_service.dart';
import '../../features/delivery/dashboard/data/datasources/mission_service.dart';
import '../../features/delivery/dashboard/data/datasources/driver_service.dart';
import '../network/services/user_service.dart';
import '../network/services/coupon_service.dart';
import '../network/services/tracking_service.dart';
import '../network/services/referral_service.dart';
import '../network/services/ai_service.dart';
import '../network/services/review_service.dart';
import '../network/services/platform_service.dart';
import '../../features/chat/data/datasources/chat_service.dart';
import '../../features/client/wallet/data/datasources/wallet_service.dart';
import '../../features/client/dispute/data/datasources/dispute_service.dart';
import '../../features/client/home/data/datasources/promotion_service.dart';
import '../../features/delivery/dashboard/data/datasources/payout_service.dart';

import '../network/pinned_client_provider.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  ChopperClient chopperClient(FlutterSecureStorage secureStorage, TokenService tokenService) {
    // We pass a lazy getter for the AuthService into the RefreshInterceptor 
    return ChopperClient(
      baseUrl: Uri.parse(EnvConfig.apiBaseUrl),
      client: PinnedHttpClientProvider.getClient(),
      services: [
        AuthService.create(),
        RestaurantService.create(),
        OrderService.create(),
        PaymentService.create(),
        MissionService.create(),
        DriverService.create(),
        UserService.create(),
        CouponService.create(),
        TrackingService.create(),
        ReferralService.create(),
        AiService.create(),
        ReviewService.create(),
        PlatformService.create(),
        ChatService.create(),
        WalletService.create(),
        DisputeService.create(),
        PromotionService.create(),
        PayoutService.create(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        ConnectivityInterceptor(),
        const TimeoutInterceptor(),
        RetryInterceptor(),
        AuthInterceptor(secureStorage),
        RefreshInterceptor(secureStorage, tokenService),
        HttpLoggingInterceptor(),
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

  @lazySingleton
  UserService getUserService(ChopperClient client) => client.getService<UserService>();

  @lazySingleton
  CouponService getCouponService(ChopperClient client) => client.getService<CouponService>();

  @lazySingleton
  TrackingService getTrackingService(ChopperClient client) => client.getService<TrackingService>();

  @lazySingleton
  ReferralService getReferralService(ChopperClient client) => client.getService<ReferralService>();

  @lazySingleton
  AiService getAiService(ChopperClient client) => client.getService<AiService>();

  @lazySingleton
  ReviewService getReviewService(ChopperClient client) => client.getService<ReviewService>();

  @lazySingleton
  PlatformService getPlatformService(ChopperClient client) => client.getService<PlatformService>();

  @lazySingleton
  ChatService getChatService(ChopperClient client) => client.getService<ChatService>();

  @lazySingleton
  WalletService getWalletService(ChopperClient client) => client.getService<WalletService>();

  @lazySingleton
  DisputeService getDisputeService(ChopperClient client) => client.getService<DisputeService>();

  @lazySingleton
  PromotionService getPromotionService(ChopperClient client) => client.getService<PromotionService>();

  @lazySingleton
  PayoutService getPayoutService(ChopperClient client) => client.getService<PayoutService>();
}

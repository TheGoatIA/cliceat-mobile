import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/socket_service.dart';
import '../../features/auth/data/datasources/auth_service.dart';
import '../../features/client/home/data/datasources/restaurant_service.dart';
import '../network/services/delivery_service.dart';
import '../network/services/order_service.dart';
import '../network/services/payment_service.dart';
import '../network/services/chat_service.dart';
import '../network/services/tracking_service.dart';
import '../network/services/user_profile_service.dart';
import '../network/services/coupon_service.dart';
import '../network/services/banner_service.dart';
import '../services/notification_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  final chopperClient = buildChopperClient();
  const secureStorage = FlutterSecureStorage();

  getIt.registerSingleton(chopperClient);

  // Chopper services
  getIt.registerSingleton<AuthService>(
      chopperClient.getService<AuthService>());
  getIt.registerSingleton<RestaurantService>(
      chopperClient.getService<RestaurantService>());
  getIt.registerSingleton<DeliveryService>(
      chopperClient.getService<DeliveryService>());
  getIt.registerSingleton<OrderService>(
      chopperClient.getService<OrderService>());
  getIt.registerSingleton<PaymentService>(
      chopperClient.getService<PaymentService>());
  getIt.registerSingleton<ChatService>(
      chopperClient.getService<ChatService>());
  getIt.registerSingleton<TrackingService>(
      chopperClient.getService<TrackingService>());
  getIt.registerSingleton<UserProfileService>(
      chopperClient.getService<UserProfileService>());
  getIt.registerSingleton<CouponService>(
      chopperClient.getService<CouponService>());
  getIt.registerSingleton<BannerService>(
      chopperClient.getService<BannerService>());

  // Core services
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  getIt.registerSingleton<SocketService>(SocketService(secureStorage));
  getIt.registerSingleton<NotificationService>(
      NotificationService(getIt<UserProfileService>()));
}

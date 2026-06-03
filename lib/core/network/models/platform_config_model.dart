import 'package:freezed_annotation/freezed_annotation.dart';


part 'platform_config_model.freezed.dart';
part 'platform_config_model.g.dart';

@freezed
abstract class PlatformConfigModel with _$PlatformConfigModel {
  const factory PlatformConfigModel({
    @JsonKey(name: 'maintenance_mode') @Default(false) bool maintenanceMode,
    @JsonKey(name: 'maintenance_message_fr') String? maintenanceMessageFr,
    @JsonKey(name: 'maintenance_message_en') String? maintenanceMessageEn,
    @JsonKey(name: 'active_cities') @Default([]) List<String> activeCities,
    @JsonKey(name: 'default_city') @Default('douala') String defaultCity,
    @JsonKey(name: 'android_version') String? androidVersion,
    @JsonKey(name: 'android_min_version') String? androidMinVersion,
    @JsonKey(name: 'ios_version') String? iosVersion,
    @JsonKey(name: 'ios_min_version') String? iosMinVersion,
    @JsonKey(name: 'force_update') @Default(false) bool forceUpdate,
    @JsonKey(name: 'update_url') String? updateUrl,
    @JsonKey(name: 'ios_update_url') String? iosUpdateUrl,
    @JsonKey(name: 'update_message_fr') String? updateMessageFr,
    @JsonKey(name: 'update_message_en') String? updateMessageEn,
    @JsonKey(name: 'support_phone') String? supportPhone,
    @JsonKey(name: 'support_email') String? supportEmail,
    @JsonKey(name: 'terms_url') String? termsUrl,
    @JsonKey(name: 'privacy_url') String? privacyUrl,
    @Default([]) List<String> features,
    PaymentConfig? payment,
    DeliveryConfig? delivery,
    LoyaltyConfig? loyalty,
  }) = _PlatformConfigModel;

  factory PlatformConfigModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformConfigModelFromJson(json);
}

@freezed
abstract class PaymentConfig with _$PaymentConfig {
  const factory PaymentConfig({
    @JsonKey(name: 'enabled_methods') @Default(['cm.mtn', 'cm.orange']) List<String> enabledMethods,
    @JsonKey(name: 'minimum_order_amount') @Default(1000) int minimumOrderAmount,
    @JsonKey(name: 'wallet_enabled') @Default(true) bool walletEnabled,
  }) = _PaymentConfig;

  factory PaymentConfig.fromJson(Map<String, dynamic> json) =>
      _$PaymentConfigFromJson(json);
}

@freezed
abstract class DeliveryConfig with _$DeliveryConfig {
  const factory DeliveryConfig({
    @JsonKey(name: 'base_fee') @Default(500) int baseFee,
    @JsonKey(name: 'per_km_fee') @Default(100) int perKmFee,
    @JsonKey(name: 'max_fee') @Default(2000) int maxFee,
    @JsonKey(name: 'free_delivery_threshold') int? freeDeliveryThreshold,
  }) = _DeliveryConfig;

  factory DeliveryConfig.fromJson(Map<String, dynamic> json) =>
      _$DeliveryConfigFromJson(json);
}

@freezed
abstract class LoyaltyConfig with _$LoyaltyConfig {
  const factory LoyaltyConfig({
    @Default(false) bool enabled,
    @JsonKey(name: 'points_per_xaf') @Default(1.0) double pointsPerXAF,
    @JsonKey(name: 'points_value_xaf') @Default(1.0) double pointsValueXAF,
    @JsonKey(name: 'welcome_bonus') @Default(100) int welcomeBonus,
  }) = _LoyaltyConfig;

  factory LoyaltyConfig.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyConfigFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlatformConfigModel _$PlatformConfigModelFromJson(Map<String, dynamic> json) =>
    _PlatformConfigModel(
      maintenanceMode: json['maintenance_mode'] as bool? ?? false,
      maintenanceMessageFr: json['maintenance_message_fr'] as String?,
      maintenanceMessageEn: json['maintenance_message_en'] as String?,
      activeCities:
          (json['active_cities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      defaultCity: json['default_city'] as String? ?? 'douala',
      androidVersion: json['android_version'] as String?,
      androidMinVersion: json['android_min_version'] as String?,
      iosVersion: json['ios_version'] as String?,
      iosMinVersion: json['ios_min_version'] as String?,
      forceUpdate: json['force_update'] as bool? ?? false,
      updateUrl: json['update_url'] as String?,
      iosUpdateUrl: json['ios_update_url'] as String?,
      updateMessageFr: json['update_message_fr'] as String?,
      updateMessageEn: json['update_message_en'] as String?,
      supportPhone: json['support_phone'] as String?,
      supportEmail: json['support_email'] as String?,
      termsUrl: json['terms_url'] as String?,
      privacyUrl: json['privacy_url'] as String?,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      payment: json['payment'] == null
          ? null
          : PaymentConfig.fromJson(json['payment'] as Map<String, dynamic>),
      delivery: json['delivery'] == null
          ? null
          : DeliveryConfig.fromJson(json['delivery'] as Map<String, dynamic>),
      loyalty: json['loyalty'] == null
          ? null
          : LoyaltyConfig.fromJson(json['loyalty'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformConfigModelToJson(
  _PlatformConfigModel instance,
) => <String, dynamic>{
  'maintenance_mode': instance.maintenanceMode,
  'maintenance_message_fr': instance.maintenanceMessageFr,
  'maintenance_message_en': instance.maintenanceMessageEn,
  'active_cities': instance.activeCities,
  'default_city': instance.defaultCity,
  'android_version': instance.androidVersion,
  'android_min_version': instance.androidMinVersion,
  'ios_version': instance.iosVersion,
  'ios_min_version': instance.iosMinVersion,
  'force_update': instance.forceUpdate,
  'update_url': instance.updateUrl,
  'ios_update_url': instance.iosUpdateUrl,
  'update_message_fr': instance.updateMessageFr,
  'update_message_en': instance.updateMessageEn,
  'support_phone': instance.supportPhone,
  'support_email': instance.supportEmail,
  'terms_url': instance.termsUrl,
  'privacy_url': instance.privacyUrl,
  'features': instance.features,
  'payment': instance.payment,
  'delivery': instance.delivery,
  'loyalty': instance.loyalty,
};

_PaymentConfig _$PaymentConfigFromJson(Map<String, dynamic> json) =>
    _PaymentConfig(
      enabledMethods:
          (json['enabled_methods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['cm.mtn', 'cm.orange'],
      minimumOrderAmount:
          (json['minimum_order_amount'] as num?)?.toInt() ?? 1000,
      walletEnabled: json['wallet_enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$PaymentConfigToJson(_PaymentConfig instance) =>
    <String, dynamic>{
      'enabled_methods': instance.enabledMethods,
      'minimum_order_amount': instance.minimumOrderAmount,
      'wallet_enabled': instance.walletEnabled,
    };

_DeliveryConfig _$DeliveryConfigFromJson(Map<String, dynamic> json) =>
    _DeliveryConfig(
      baseFee: (json['base_fee'] as num?)?.toInt() ?? 500,
      perKmFee: (json['per_km_fee'] as num?)?.toInt() ?? 100,
      maxFee: (json['max_fee'] as num?)?.toInt() ?? 2000,
      freeDeliveryThreshold: (json['free_delivery_threshold'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DeliveryConfigToJson(_DeliveryConfig instance) =>
    <String, dynamic>{
      'base_fee': instance.baseFee,
      'per_km_fee': instance.perKmFee,
      'max_fee': instance.maxFee,
      'free_delivery_threshold': instance.freeDeliveryThreshold,
    };

_LoyaltyConfig _$LoyaltyConfigFromJson(Map<String, dynamic> json) =>
    _LoyaltyConfig(
      enabled: json['enabled'] as bool? ?? false,
      pointsPerXAF: (json['points_per_xaf'] as num?)?.toDouble() ?? 1.0,
      pointsValueXAF: (json['points_value_xaf'] as num?)?.toDouble() ?? 1.0,
      welcomeBonus: (json['welcome_bonus'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$LoyaltyConfigToJson(_LoyaltyConfig instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'points_per_xaf': instance.pointsPerXAF,
      'points_value_xaf': instance.pointsValueXAF,
      'welcome_bonus': instance.welcomeBonus,
    };

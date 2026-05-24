// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformConfigModel {

@JsonKey(name: 'maintenance_mode') bool get maintenanceMode;@JsonKey(name: 'maintenance_message_fr') String? get maintenanceMessageFr;@JsonKey(name: 'maintenance_message_en') String? get maintenanceMessageEn;@JsonKey(name: 'active_cities') List<String> get activeCities;@JsonKey(name: 'default_city') String get defaultCity;@JsonKey(name: 'android_version') String? get androidVersion;@JsonKey(name: 'ios_version') String? get iosVersion;@JsonKey(name: 'force_update') bool get forceUpdate;@JsonKey(name: 'update_url') String? get updateUrl;@JsonKey(name: 'support_phone') String? get supportPhone;@JsonKey(name: 'support_email') String? get supportEmail;@JsonKey(name: 'terms_url') String? get termsUrl;@JsonKey(name: 'privacy_url') String? get privacyUrl; List<String> get features; PaymentConfig? get payment; DeliveryConfig? get delivery; LoyaltyConfig? get loyalty;
/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformConfigModelCopyWith<PlatformConfigModel> get copyWith => _$PlatformConfigModelCopyWithImpl<PlatformConfigModel>(this as PlatformConfigModel, _$identity);

  /// Serializes this PlatformConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformConfigModel&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.maintenanceMessageFr, maintenanceMessageFr) || other.maintenanceMessageFr == maintenanceMessageFr)&&(identical(other.maintenanceMessageEn, maintenanceMessageEn) || other.maintenanceMessageEn == maintenanceMessageEn)&&const DeepCollectionEquality().equals(other.activeCities, activeCities)&&(identical(other.defaultCity, defaultCity) || other.defaultCity == defaultCity)&&(identical(other.androidVersion, androidVersion) || other.androidVersion == androidVersion)&&(identical(other.iosVersion, iosVersion) || other.iosVersion == iosVersion)&&(identical(other.forceUpdate, forceUpdate) || other.forceUpdate == forceUpdate)&&(identical(other.updateUrl, updateUrl) || other.updateUrl == updateUrl)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.supportEmail, supportEmail) || other.supportEmail == supportEmail)&&(identical(other.termsUrl, termsUrl) || other.termsUrl == termsUrl)&&(identical(other.privacyUrl, privacyUrl) || other.privacyUrl == privacyUrl)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.delivery, delivery) || other.delivery == delivery)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maintenanceMode,maintenanceMessageFr,maintenanceMessageEn,const DeepCollectionEquality().hash(activeCities),defaultCity,androidVersion,iosVersion,forceUpdate,updateUrl,supportPhone,supportEmail,termsUrl,privacyUrl,const DeepCollectionEquality().hash(features),payment,delivery,loyalty);

@override
String toString() {
  return 'PlatformConfigModel(maintenanceMode: $maintenanceMode, maintenanceMessageFr: $maintenanceMessageFr, maintenanceMessageEn: $maintenanceMessageEn, activeCities: $activeCities, defaultCity: $defaultCity, androidVersion: $androidVersion, iosVersion: $iosVersion, forceUpdate: $forceUpdate, updateUrl: $updateUrl, supportPhone: $supportPhone, supportEmail: $supportEmail, termsUrl: $termsUrl, privacyUrl: $privacyUrl, features: $features, payment: $payment, delivery: $delivery, loyalty: $loyalty)';
}


}

/// @nodoc
abstract mixin class $PlatformConfigModelCopyWith<$Res>  {
  factory $PlatformConfigModelCopyWith(PlatformConfigModel value, $Res Function(PlatformConfigModel) _then) = _$PlatformConfigModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'maintenance_mode') bool maintenanceMode,@JsonKey(name: 'maintenance_message_fr') String? maintenanceMessageFr,@JsonKey(name: 'maintenance_message_en') String? maintenanceMessageEn,@JsonKey(name: 'active_cities') List<String> activeCities,@JsonKey(name: 'default_city') String defaultCity,@JsonKey(name: 'android_version') String? androidVersion,@JsonKey(name: 'ios_version') String? iosVersion,@JsonKey(name: 'force_update') bool forceUpdate,@JsonKey(name: 'update_url') String? updateUrl,@JsonKey(name: 'support_phone') String? supportPhone,@JsonKey(name: 'support_email') String? supportEmail,@JsonKey(name: 'terms_url') String? termsUrl,@JsonKey(name: 'privacy_url') String? privacyUrl, List<String> features, PaymentConfig? payment, DeliveryConfig? delivery, LoyaltyConfig? loyalty
});


$PaymentConfigCopyWith<$Res>? get payment;$DeliveryConfigCopyWith<$Res>? get delivery;$LoyaltyConfigCopyWith<$Res>? get loyalty;

}
/// @nodoc
class _$PlatformConfigModelCopyWithImpl<$Res>
    implements $PlatformConfigModelCopyWith<$Res> {
  _$PlatformConfigModelCopyWithImpl(this._self, this._then);

  final PlatformConfigModel _self;
  final $Res Function(PlatformConfigModel) _then;

/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maintenanceMode = null,Object? maintenanceMessageFr = freezed,Object? maintenanceMessageEn = freezed,Object? activeCities = null,Object? defaultCity = null,Object? androidVersion = freezed,Object? iosVersion = freezed,Object? forceUpdate = null,Object? updateUrl = freezed,Object? supportPhone = freezed,Object? supportEmail = freezed,Object? termsUrl = freezed,Object? privacyUrl = freezed,Object? features = null,Object? payment = freezed,Object? delivery = freezed,Object? loyalty = freezed,}) {
  return _then(_self.copyWith(
maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMessageFr: freezed == maintenanceMessageFr ? _self.maintenanceMessageFr : maintenanceMessageFr // ignore: cast_nullable_to_non_nullable
as String?,maintenanceMessageEn: freezed == maintenanceMessageEn ? _self.maintenanceMessageEn : maintenanceMessageEn // ignore: cast_nullable_to_non_nullable
as String?,activeCities: null == activeCities ? _self.activeCities : activeCities // ignore: cast_nullable_to_non_nullable
as List<String>,defaultCity: null == defaultCity ? _self.defaultCity : defaultCity // ignore: cast_nullable_to_non_nullable
as String,androidVersion: freezed == androidVersion ? _self.androidVersion : androidVersion // ignore: cast_nullable_to_non_nullable
as String?,iosVersion: freezed == iosVersion ? _self.iosVersion : iosVersion // ignore: cast_nullable_to_non_nullable
as String?,forceUpdate: null == forceUpdate ? _self.forceUpdate : forceUpdate // ignore: cast_nullable_to_non_nullable
as bool,updateUrl: freezed == updateUrl ? _self.updateUrl : updateUrl // ignore: cast_nullable_to_non_nullable
as String?,supportPhone: freezed == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String?,supportEmail: freezed == supportEmail ? _self.supportEmail : supportEmail // ignore: cast_nullable_to_non_nullable
as String?,termsUrl: freezed == termsUrl ? _self.termsUrl : termsUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyUrl: freezed == privacyUrl ? _self.privacyUrl : privacyUrl // ignore: cast_nullable_to_non_nullable
as String?,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentConfig?,delivery: freezed == delivery ? _self.delivery : delivery // ignore: cast_nullable_to_non_nullable
as DeliveryConfig?,loyalty: freezed == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as LoyaltyConfig?,
  ));
}
/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentConfigCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $PaymentConfigCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryConfigCopyWith<$Res>? get delivery {
    if (_self.delivery == null) {
    return null;
  }

  return $DeliveryConfigCopyWith<$Res>(_self.delivery!, (value) {
    return _then(_self.copyWith(delivery: value));
  });
}/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoyaltyConfigCopyWith<$Res>? get loyalty {
    if (_self.loyalty == null) {
    return null;
  }

  return $LoyaltyConfigCopyWith<$Res>(_self.loyalty!, (value) {
    return _then(_self.copyWith(loyalty: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlatformConfigModel].
extension PlatformConfigModelPatterns on PlatformConfigModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformConfigModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _PlatformConfigModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformConfigModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'maintenance_mode')  bool maintenanceMode, @JsonKey(name: 'maintenance_message_fr')  String? maintenanceMessageFr, @JsonKey(name: 'maintenance_message_en')  String? maintenanceMessageEn, @JsonKey(name: 'active_cities')  List<String> activeCities, @JsonKey(name: 'default_city')  String defaultCity, @JsonKey(name: 'android_version')  String? androidVersion, @JsonKey(name: 'ios_version')  String? iosVersion, @JsonKey(name: 'force_update')  bool forceUpdate, @JsonKey(name: 'update_url')  String? updateUrl, @JsonKey(name: 'support_phone')  String? supportPhone, @JsonKey(name: 'support_email')  String? supportEmail, @JsonKey(name: 'terms_url')  String? termsUrl, @JsonKey(name: 'privacy_url')  String? privacyUrl,  List<String> features,  PaymentConfig? payment,  DeliveryConfig? delivery,  LoyaltyConfig? loyalty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformConfigModel() when $default != null:
return $default(_that.maintenanceMode,_that.maintenanceMessageFr,_that.maintenanceMessageEn,_that.activeCities,_that.defaultCity,_that.androidVersion,_that.iosVersion,_that.forceUpdate,_that.updateUrl,_that.supportPhone,_that.supportEmail,_that.termsUrl,_that.privacyUrl,_that.features,_that.payment,_that.delivery,_that.loyalty);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'maintenance_mode')  bool maintenanceMode, @JsonKey(name: 'maintenance_message_fr')  String? maintenanceMessageFr, @JsonKey(name: 'maintenance_message_en')  String? maintenanceMessageEn, @JsonKey(name: 'active_cities')  List<String> activeCities, @JsonKey(name: 'default_city')  String defaultCity, @JsonKey(name: 'android_version')  String? androidVersion, @JsonKey(name: 'ios_version')  String? iosVersion, @JsonKey(name: 'force_update')  bool forceUpdate, @JsonKey(name: 'update_url')  String? updateUrl, @JsonKey(name: 'support_phone')  String? supportPhone, @JsonKey(name: 'support_email')  String? supportEmail, @JsonKey(name: 'terms_url')  String? termsUrl, @JsonKey(name: 'privacy_url')  String? privacyUrl,  List<String> features,  PaymentConfig? payment,  DeliveryConfig? delivery,  LoyaltyConfig? loyalty)  $default,) {final _that = this;
switch (_that) {
case _PlatformConfigModel():
return $default(_that.maintenanceMode,_that.maintenanceMessageFr,_that.maintenanceMessageEn,_that.activeCities,_that.defaultCity,_that.androidVersion,_that.iosVersion,_that.forceUpdate,_that.updateUrl,_that.supportPhone,_that.supportEmail,_that.termsUrl,_that.privacyUrl,_that.features,_that.payment,_that.delivery,_that.loyalty);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'maintenance_mode')  bool maintenanceMode, @JsonKey(name: 'maintenance_message_fr')  String? maintenanceMessageFr, @JsonKey(name: 'maintenance_message_en')  String? maintenanceMessageEn, @JsonKey(name: 'active_cities')  List<String> activeCities, @JsonKey(name: 'default_city')  String defaultCity, @JsonKey(name: 'android_version')  String? androidVersion, @JsonKey(name: 'ios_version')  String? iosVersion, @JsonKey(name: 'force_update')  bool forceUpdate, @JsonKey(name: 'update_url')  String? updateUrl, @JsonKey(name: 'support_phone')  String? supportPhone, @JsonKey(name: 'support_email')  String? supportEmail, @JsonKey(name: 'terms_url')  String? termsUrl, @JsonKey(name: 'privacy_url')  String? privacyUrl,  List<String> features,  PaymentConfig? payment,  DeliveryConfig? delivery,  LoyaltyConfig? loyalty)?  $default,) {final _that = this;
switch (_that) {
case _PlatformConfigModel() when $default != null:
return $default(_that.maintenanceMode,_that.maintenanceMessageFr,_that.maintenanceMessageEn,_that.activeCities,_that.defaultCity,_that.androidVersion,_that.iosVersion,_that.forceUpdate,_that.updateUrl,_that.supportPhone,_that.supportEmail,_that.termsUrl,_that.privacyUrl,_that.features,_that.payment,_that.delivery,_that.loyalty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformConfigModel implements PlatformConfigModel {
  const _PlatformConfigModel({@JsonKey(name: 'maintenance_mode') this.maintenanceMode = false, @JsonKey(name: 'maintenance_message_fr') this.maintenanceMessageFr, @JsonKey(name: 'maintenance_message_en') this.maintenanceMessageEn, @JsonKey(name: 'active_cities') final  List<String> activeCities = const [], @JsonKey(name: 'default_city') this.defaultCity = 'douala', @JsonKey(name: 'android_version') this.androidVersion, @JsonKey(name: 'ios_version') this.iosVersion, @JsonKey(name: 'force_update') this.forceUpdate = false, @JsonKey(name: 'update_url') this.updateUrl, @JsonKey(name: 'support_phone') this.supportPhone, @JsonKey(name: 'support_email') this.supportEmail, @JsonKey(name: 'terms_url') this.termsUrl, @JsonKey(name: 'privacy_url') this.privacyUrl, final  List<String> features = const [], this.payment, this.delivery, this.loyalty}): _activeCities = activeCities,_features = features;
  factory _PlatformConfigModel.fromJson(Map<String, dynamic> json) => _$PlatformConfigModelFromJson(json);

@override@JsonKey(name: 'maintenance_mode') final  bool maintenanceMode;
@override@JsonKey(name: 'maintenance_message_fr') final  String? maintenanceMessageFr;
@override@JsonKey(name: 'maintenance_message_en') final  String? maintenanceMessageEn;
 final  List<String> _activeCities;
@override@JsonKey(name: 'active_cities') List<String> get activeCities {
  if (_activeCities is EqualUnmodifiableListView) return _activeCities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeCities);
}

@override@JsonKey(name: 'default_city') final  String defaultCity;
@override@JsonKey(name: 'android_version') final  String? androidVersion;
@override@JsonKey(name: 'ios_version') final  String? iosVersion;
@override@JsonKey(name: 'force_update') final  bool forceUpdate;
@override@JsonKey(name: 'update_url') final  String? updateUrl;
@override@JsonKey(name: 'support_phone') final  String? supportPhone;
@override@JsonKey(name: 'support_email') final  String? supportEmail;
@override@JsonKey(name: 'terms_url') final  String? termsUrl;
@override@JsonKey(name: 'privacy_url') final  String? privacyUrl;
 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

@override final  PaymentConfig? payment;
@override final  DeliveryConfig? delivery;
@override final  LoyaltyConfig? loyalty;

/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformConfigModelCopyWith<_PlatformConfigModel> get copyWith => __$PlatformConfigModelCopyWithImpl<_PlatformConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformConfigModel&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.maintenanceMessageFr, maintenanceMessageFr) || other.maintenanceMessageFr == maintenanceMessageFr)&&(identical(other.maintenanceMessageEn, maintenanceMessageEn) || other.maintenanceMessageEn == maintenanceMessageEn)&&const DeepCollectionEquality().equals(other._activeCities, _activeCities)&&(identical(other.defaultCity, defaultCity) || other.defaultCity == defaultCity)&&(identical(other.androidVersion, androidVersion) || other.androidVersion == androidVersion)&&(identical(other.iosVersion, iosVersion) || other.iosVersion == iosVersion)&&(identical(other.forceUpdate, forceUpdate) || other.forceUpdate == forceUpdate)&&(identical(other.updateUrl, updateUrl) || other.updateUrl == updateUrl)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.supportEmail, supportEmail) || other.supportEmail == supportEmail)&&(identical(other.termsUrl, termsUrl) || other.termsUrl == termsUrl)&&(identical(other.privacyUrl, privacyUrl) || other.privacyUrl == privacyUrl)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.delivery, delivery) || other.delivery == delivery)&&(identical(other.loyalty, loyalty) || other.loyalty == loyalty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maintenanceMode,maintenanceMessageFr,maintenanceMessageEn,const DeepCollectionEquality().hash(_activeCities),defaultCity,androidVersion,iosVersion,forceUpdate,updateUrl,supportPhone,supportEmail,termsUrl,privacyUrl,const DeepCollectionEquality().hash(_features),payment,delivery,loyalty);

@override
String toString() {
  return 'PlatformConfigModel(maintenanceMode: $maintenanceMode, maintenanceMessageFr: $maintenanceMessageFr, maintenanceMessageEn: $maintenanceMessageEn, activeCities: $activeCities, defaultCity: $defaultCity, androidVersion: $androidVersion, iosVersion: $iosVersion, forceUpdate: $forceUpdate, updateUrl: $updateUrl, supportPhone: $supportPhone, supportEmail: $supportEmail, termsUrl: $termsUrl, privacyUrl: $privacyUrl, features: $features, payment: $payment, delivery: $delivery, loyalty: $loyalty)';
}


}

/// @nodoc
abstract mixin class _$PlatformConfigModelCopyWith<$Res> implements $PlatformConfigModelCopyWith<$Res> {
  factory _$PlatformConfigModelCopyWith(_PlatformConfigModel value, $Res Function(_PlatformConfigModel) _then) = __$PlatformConfigModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'maintenance_mode') bool maintenanceMode,@JsonKey(name: 'maintenance_message_fr') String? maintenanceMessageFr,@JsonKey(name: 'maintenance_message_en') String? maintenanceMessageEn,@JsonKey(name: 'active_cities') List<String> activeCities,@JsonKey(name: 'default_city') String defaultCity,@JsonKey(name: 'android_version') String? androidVersion,@JsonKey(name: 'ios_version') String? iosVersion,@JsonKey(name: 'force_update') bool forceUpdate,@JsonKey(name: 'update_url') String? updateUrl,@JsonKey(name: 'support_phone') String? supportPhone,@JsonKey(name: 'support_email') String? supportEmail,@JsonKey(name: 'terms_url') String? termsUrl,@JsonKey(name: 'privacy_url') String? privacyUrl, List<String> features, PaymentConfig? payment, DeliveryConfig? delivery, LoyaltyConfig? loyalty
});


@override $PaymentConfigCopyWith<$Res>? get payment;@override $DeliveryConfigCopyWith<$Res>? get delivery;@override $LoyaltyConfigCopyWith<$Res>? get loyalty;

}
/// @nodoc
class __$PlatformConfigModelCopyWithImpl<$Res>
    implements _$PlatformConfigModelCopyWith<$Res> {
  __$PlatformConfigModelCopyWithImpl(this._self, this._then);

  final _PlatformConfigModel _self;
  final $Res Function(_PlatformConfigModel) _then;

/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maintenanceMode = null,Object? maintenanceMessageFr = freezed,Object? maintenanceMessageEn = freezed,Object? activeCities = null,Object? defaultCity = null,Object? androidVersion = freezed,Object? iosVersion = freezed,Object? forceUpdate = null,Object? updateUrl = freezed,Object? supportPhone = freezed,Object? supportEmail = freezed,Object? termsUrl = freezed,Object? privacyUrl = freezed,Object? features = null,Object? payment = freezed,Object? delivery = freezed,Object? loyalty = freezed,}) {
  return _then(_PlatformConfigModel(
maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMessageFr: freezed == maintenanceMessageFr ? _self.maintenanceMessageFr : maintenanceMessageFr // ignore: cast_nullable_to_non_nullable
as String?,maintenanceMessageEn: freezed == maintenanceMessageEn ? _self.maintenanceMessageEn : maintenanceMessageEn // ignore: cast_nullable_to_non_nullable
as String?,activeCities: null == activeCities ? _self._activeCities : activeCities // ignore: cast_nullable_to_non_nullable
as List<String>,defaultCity: null == defaultCity ? _self.defaultCity : defaultCity // ignore: cast_nullable_to_non_nullable
as String,androidVersion: freezed == androidVersion ? _self.androidVersion : androidVersion // ignore: cast_nullable_to_non_nullable
as String?,iosVersion: freezed == iosVersion ? _self.iosVersion : iosVersion // ignore: cast_nullable_to_non_nullable
as String?,forceUpdate: null == forceUpdate ? _self.forceUpdate : forceUpdate // ignore: cast_nullable_to_non_nullable
as bool,updateUrl: freezed == updateUrl ? _self.updateUrl : updateUrl // ignore: cast_nullable_to_non_nullable
as String?,supportPhone: freezed == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String?,supportEmail: freezed == supportEmail ? _self.supportEmail : supportEmail // ignore: cast_nullable_to_non_nullable
as String?,termsUrl: freezed == termsUrl ? _self.termsUrl : termsUrl // ignore: cast_nullable_to_non_nullable
as String?,privacyUrl: freezed == privacyUrl ? _self.privacyUrl : privacyUrl // ignore: cast_nullable_to_non_nullable
as String?,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentConfig?,delivery: freezed == delivery ? _self.delivery : delivery // ignore: cast_nullable_to_non_nullable
as DeliveryConfig?,loyalty: freezed == loyalty ? _self.loyalty : loyalty // ignore: cast_nullable_to_non_nullable
as LoyaltyConfig?,
  ));
}

/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentConfigCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $PaymentConfigCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryConfigCopyWith<$Res>? get delivery {
    if (_self.delivery == null) {
    return null;
  }

  return $DeliveryConfigCopyWith<$Res>(_self.delivery!, (value) {
    return _then(_self.copyWith(delivery: value));
  });
}/// Create a copy of PlatformConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoyaltyConfigCopyWith<$Res>? get loyalty {
    if (_self.loyalty == null) {
    return null;
  }

  return $LoyaltyConfigCopyWith<$Res>(_self.loyalty!, (value) {
    return _then(_self.copyWith(loyalty: value));
  });
}
}


/// @nodoc
mixin _$PaymentConfig {

@JsonKey(name: 'enabled_methods') List<String> get enabledMethods;@JsonKey(name: 'minimum_order_amount') int get minimumOrderAmount;@JsonKey(name: 'wallet_enabled') bool get walletEnabled;
/// Create a copy of PaymentConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentConfigCopyWith<PaymentConfig> get copyWith => _$PaymentConfigCopyWithImpl<PaymentConfig>(this as PaymentConfig, _$identity);

  /// Serializes this PaymentConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentConfig&&const DeepCollectionEquality().equals(other.enabledMethods, enabledMethods)&&(identical(other.minimumOrderAmount, minimumOrderAmount) || other.minimumOrderAmount == minimumOrderAmount)&&(identical(other.walletEnabled, walletEnabled) || other.walletEnabled == walletEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(enabledMethods),minimumOrderAmount,walletEnabled);

@override
String toString() {
  return 'PaymentConfig(enabledMethods: $enabledMethods, minimumOrderAmount: $minimumOrderAmount, walletEnabled: $walletEnabled)';
}


}

/// @nodoc
abstract mixin class $PaymentConfigCopyWith<$Res>  {
  factory $PaymentConfigCopyWith(PaymentConfig value, $Res Function(PaymentConfig) _then) = _$PaymentConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'enabled_methods') List<String> enabledMethods,@JsonKey(name: 'minimum_order_amount') int minimumOrderAmount,@JsonKey(name: 'wallet_enabled') bool walletEnabled
});




}
/// @nodoc
class _$PaymentConfigCopyWithImpl<$Res>
    implements $PaymentConfigCopyWith<$Res> {
  _$PaymentConfigCopyWithImpl(this._self, this._then);

  final PaymentConfig _self;
  final $Res Function(PaymentConfig) _then;

/// Create a copy of PaymentConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabledMethods = null,Object? minimumOrderAmount = null,Object? walletEnabled = null,}) {
  return _then(_self.copyWith(
enabledMethods: null == enabledMethods ? _self.enabledMethods : enabledMethods // ignore: cast_nullable_to_non_nullable
as List<String>,minimumOrderAmount: null == minimumOrderAmount ? _self.minimumOrderAmount : minimumOrderAmount // ignore: cast_nullable_to_non_nullable
as int,walletEnabled: null == walletEnabled ? _self.walletEnabled : walletEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentConfig].
extension PaymentConfigPatterns on PaymentConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentConfig value)  $default,){
final _that = this;
switch (_that) {
case _PaymentConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'enabled_methods')  List<String> enabledMethods, @JsonKey(name: 'minimum_order_amount')  int minimumOrderAmount, @JsonKey(name: 'wallet_enabled')  bool walletEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentConfig() when $default != null:
return $default(_that.enabledMethods,_that.minimumOrderAmount,_that.walletEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'enabled_methods')  List<String> enabledMethods, @JsonKey(name: 'minimum_order_amount')  int minimumOrderAmount, @JsonKey(name: 'wallet_enabled')  bool walletEnabled)  $default,) {final _that = this;
switch (_that) {
case _PaymentConfig():
return $default(_that.enabledMethods,_that.minimumOrderAmount,_that.walletEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'enabled_methods')  List<String> enabledMethods, @JsonKey(name: 'minimum_order_amount')  int minimumOrderAmount, @JsonKey(name: 'wallet_enabled')  bool walletEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PaymentConfig() when $default != null:
return $default(_that.enabledMethods,_that.minimumOrderAmount,_that.walletEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentConfig implements PaymentConfig {
  const _PaymentConfig({@JsonKey(name: 'enabled_methods') final  List<String> enabledMethods = const ['cm.mtn', 'cm.orange'], @JsonKey(name: 'minimum_order_amount') this.minimumOrderAmount = 1000, @JsonKey(name: 'wallet_enabled') this.walletEnabled = true}): _enabledMethods = enabledMethods;
  factory _PaymentConfig.fromJson(Map<String, dynamic> json) => _$PaymentConfigFromJson(json);

 final  List<String> _enabledMethods;
@override@JsonKey(name: 'enabled_methods') List<String> get enabledMethods {
  if (_enabledMethods is EqualUnmodifiableListView) return _enabledMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_enabledMethods);
}

@override@JsonKey(name: 'minimum_order_amount') final  int minimumOrderAmount;
@override@JsonKey(name: 'wallet_enabled') final  bool walletEnabled;

/// Create a copy of PaymentConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentConfigCopyWith<_PaymentConfig> get copyWith => __$PaymentConfigCopyWithImpl<_PaymentConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentConfig&&const DeepCollectionEquality().equals(other._enabledMethods, _enabledMethods)&&(identical(other.minimumOrderAmount, minimumOrderAmount) || other.minimumOrderAmount == minimumOrderAmount)&&(identical(other.walletEnabled, walletEnabled) || other.walletEnabled == walletEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_enabledMethods),minimumOrderAmount,walletEnabled);

@override
String toString() {
  return 'PaymentConfig(enabledMethods: $enabledMethods, minimumOrderAmount: $minimumOrderAmount, walletEnabled: $walletEnabled)';
}


}

/// @nodoc
abstract mixin class _$PaymentConfigCopyWith<$Res> implements $PaymentConfigCopyWith<$Res> {
  factory _$PaymentConfigCopyWith(_PaymentConfig value, $Res Function(_PaymentConfig) _then) = __$PaymentConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'enabled_methods') List<String> enabledMethods,@JsonKey(name: 'minimum_order_amount') int minimumOrderAmount,@JsonKey(name: 'wallet_enabled') bool walletEnabled
});




}
/// @nodoc
class __$PaymentConfigCopyWithImpl<$Res>
    implements _$PaymentConfigCopyWith<$Res> {
  __$PaymentConfigCopyWithImpl(this._self, this._then);

  final _PaymentConfig _self;
  final $Res Function(_PaymentConfig) _then;

/// Create a copy of PaymentConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabledMethods = null,Object? minimumOrderAmount = null,Object? walletEnabled = null,}) {
  return _then(_PaymentConfig(
enabledMethods: null == enabledMethods ? _self._enabledMethods : enabledMethods // ignore: cast_nullable_to_non_nullable
as List<String>,minimumOrderAmount: null == minimumOrderAmount ? _self.minimumOrderAmount : minimumOrderAmount // ignore: cast_nullable_to_non_nullable
as int,walletEnabled: null == walletEnabled ? _self.walletEnabled : walletEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DeliveryConfig {

@JsonKey(name: 'base_fee') int get baseFee;@JsonKey(name: 'per_km_fee') int get perKmFee;@JsonKey(name: 'max_fee') int get maxFee;@JsonKey(name: 'free_delivery_threshold') int? get freeDeliveryThreshold;
/// Create a copy of DeliveryConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryConfigCopyWith<DeliveryConfig> get copyWith => _$DeliveryConfigCopyWithImpl<DeliveryConfig>(this as DeliveryConfig, _$identity);

  /// Serializes this DeliveryConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryConfig&&(identical(other.baseFee, baseFee) || other.baseFee == baseFee)&&(identical(other.perKmFee, perKmFee) || other.perKmFee == perKmFee)&&(identical(other.maxFee, maxFee) || other.maxFee == maxFee)&&(identical(other.freeDeliveryThreshold, freeDeliveryThreshold) || other.freeDeliveryThreshold == freeDeliveryThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseFee,perKmFee,maxFee,freeDeliveryThreshold);

@override
String toString() {
  return 'DeliveryConfig(baseFee: $baseFee, perKmFee: $perKmFee, maxFee: $maxFee, freeDeliveryThreshold: $freeDeliveryThreshold)';
}


}

/// @nodoc
abstract mixin class $DeliveryConfigCopyWith<$Res>  {
  factory $DeliveryConfigCopyWith(DeliveryConfig value, $Res Function(DeliveryConfig) _then) = _$DeliveryConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'base_fee') int baseFee,@JsonKey(name: 'per_km_fee') int perKmFee,@JsonKey(name: 'max_fee') int maxFee,@JsonKey(name: 'free_delivery_threshold') int? freeDeliveryThreshold
});




}
/// @nodoc
class _$DeliveryConfigCopyWithImpl<$Res>
    implements $DeliveryConfigCopyWith<$Res> {
  _$DeliveryConfigCopyWithImpl(this._self, this._then);

  final DeliveryConfig _self;
  final $Res Function(DeliveryConfig) _then;

/// Create a copy of DeliveryConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseFee = null,Object? perKmFee = null,Object? maxFee = null,Object? freeDeliveryThreshold = freezed,}) {
  return _then(_self.copyWith(
baseFee: null == baseFee ? _self.baseFee : baseFee // ignore: cast_nullable_to_non_nullable
as int,perKmFee: null == perKmFee ? _self.perKmFee : perKmFee // ignore: cast_nullable_to_non_nullable
as int,maxFee: null == maxFee ? _self.maxFee : maxFee // ignore: cast_nullable_to_non_nullable
as int,freeDeliveryThreshold: freezed == freeDeliveryThreshold ? _self.freeDeliveryThreshold : freeDeliveryThreshold // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryConfig].
extension DeliveryConfigPatterns on DeliveryConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryConfig value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'base_fee')  int baseFee, @JsonKey(name: 'per_km_fee')  int perKmFee, @JsonKey(name: 'max_fee')  int maxFee, @JsonKey(name: 'free_delivery_threshold')  int? freeDeliveryThreshold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryConfig() when $default != null:
return $default(_that.baseFee,_that.perKmFee,_that.maxFee,_that.freeDeliveryThreshold);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'base_fee')  int baseFee, @JsonKey(name: 'per_km_fee')  int perKmFee, @JsonKey(name: 'max_fee')  int maxFee, @JsonKey(name: 'free_delivery_threshold')  int? freeDeliveryThreshold)  $default,) {final _that = this;
switch (_that) {
case _DeliveryConfig():
return $default(_that.baseFee,_that.perKmFee,_that.maxFee,_that.freeDeliveryThreshold);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'base_fee')  int baseFee, @JsonKey(name: 'per_km_fee')  int perKmFee, @JsonKey(name: 'max_fee')  int maxFee, @JsonKey(name: 'free_delivery_threshold')  int? freeDeliveryThreshold)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryConfig() when $default != null:
return $default(_that.baseFee,_that.perKmFee,_that.maxFee,_that.freeDeliveryThreshold);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryConfig implements DeliveryConfig {
  const _DeliveryConfig({@JsonKey(name: 'base_fee') this.baseFee = 500, @JsonKey(name: 'per_km_fee') this.perKmFee = 100, @JsonKey(name: 'max_fee') this.maxFee = 2000, @JsonKey(name: 'free_delivery_threshold') this.freeDeliveryThreshold});
  factory _DeliveryConfig.fromJson(Map<String, dynamic> json) => _$DeliveryConfigFromJson(json);

@override@JsonKey(name: 'base_fee') final  int baseFee;
@override@JsonKey(name: 'per_km_fee') final  int perKmFee;
@override@JsonKey(name: 'max_fee') final  int maxFee;
@override@JsonKey(name: 'free_delivery_threshold') final  int? freeDeliveryThreshold;

/// Create a copy of DeliveryConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryConfigCopyWith<_DeliveryConfig> get copyWith => __$DeliveryConfigCopyWithImpl<_DeliveryConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryConfig&&(identical(other.baseFee, baseFee) || other.baseFee == baseFee)&&(identical(other.perKmFee, perKmFee) || other.perKmFee == perKmFee)&&(identical(other.maxFee, maxFee) || other.maxFee == maxFee)&&(identical(other.freeDeliveryThreshold, freeDeliveryThreshold) || other.freeDeliveryThreshold == freeDeliveryThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseFee,perKmFee,maxFee,freeDeliveryThreshold);

@override
String toString() {
  return 'DeliveryConfig(baseFee: $baseFee, perKmFee: $perKmFee, maxFee: $maxFee, freeDeliveryThreshold: $freeDeliveryThreshold)';
}


}

/// @nodoc
abstract mixin class _$DeliveryConfigCopyWith<$Res> implements $DeliveryConfigCopyWith<$Res> {
  factory _$DeliveryConfigCopyWith(_DeliveryConfig value, $Res Function(_DeliveryConfig) _then) = __$DeliveryConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'base_fee') int baseFee,@JsonKey(name: 'per_km_fee') int perKmFee,@JsonKey(name: 'max_fee') int maxFee,@JsonKey(name: 'free_delivery_threshold') int? freeDeliveryThreshold
});




}
/// @nodoc
class __$DeliveryConfigCopyWithImpl<$Res>
    implements _$DeliveryConfigCopyWith<$Res> {
  __$DeliveryConfigCopyWithImpl(this._self, this._then);

  final _DeliveryConfig _self;
  final $Res Function(_DeliveryConfig) _then;

/// Create a copy of DeliveryConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseFee = null,Object? perKmFee = null,Object? maxFee = null,Object? freeDeliveryThreshold = freezed,}) {
  return _then(_DeliveryConfig(
baseFee: null == baseFee ? _self.baseFee : baseFee // ignore: cast_nullable_to_non_nullable
as int,perKmFee: null == perKmFee ? _self.perKmFee : perKmFee // ignore: cast_nullable_to_non_nullable
as int,maxFee: null == maxFee ? _self.maxFee : maxFee // ignore: cast_nullable_to_non_nullable
as int,freeDeliveryThreshold: freezed == freeDeliveryThreshold ? _self.freeDeliveryThreshold : freeDeliveryThreshold // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LoyaltyConfig {

 bool get enabled;@JsonKey(name: 'points_per_xaf') double get pointsPerXAF;@JsonKey(name: 'points_value_xaf') double get pointsValueXAF;@JsonKey(name: 'welcome_bonus') int get welcomeBonus;
/// Create a copy of LoyaltyConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyConfigCopyWith<LoyaltyConfig> get copyWith => _$LoyaltyConfigCopyWithImpl<LoyaltyConfig>(this as LoyaltyConfig, _$identity);

  /// Serializes this LoyaltyConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.pointsPerXAF, pointsPerXAF) || other.pointsPerXAF == pointsPerXAF)&&(identical(other.pointsValueXAF, pointsValueXAF) || other.pointsValueXAF == pointsValueXAF)&&(identical(other.welcomeBonus, welcomeBonus) || other.welcomeBonus == welcomeBonus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,pointsPerXAF,pointsValueXAF,welcomeBonus);

@override
String toString() {
  return 'LoyaltyConfig(enabled: $enabled, pointsPerXAF: $pointsPerXAF, pointsValueXAF: $pointsValueXAF, welcomeBonus: $welcomeBonus)';
}


}

/// @nodoc
abstract mixin class $LoyaltyConfigCopyWith<$Res>  {
  factory $LoyaltyConfigCopyWith(LoyaltyConfig value, $Res Function(LoyaltyConfig) _then) = _$LoyaltyConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled,@JsonKey(name: 'points_per_xaf') double pointsPerXAF,@JsonKey(name: 'points_value_xaf') double pointsValueXAF,@JsonKey(name: 'welcome_bonus') int welcomeBonus
});




}
/// @nodoc
class _$LoyaltyConfigCopyWithImpl<$Res>
    implements $LoyaltyConfigCopyWith<$Res> {
  _$LoyaltyConfigCopyWithImpl(this._self, this._then);

  final LoyaltyConfig _self;
  final $Res Function(LoyaltyConfig) _then;

/// Create a copy of LoyaltyConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? pointsPerXAF = null,Object? pointsValueXAF = null,Object? welcomeBonus = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,pointsPerXAF: null == pointsPerXAF ? _self.pointsPerXAF : pointsPerXAF // ignore: cast_nullable_to_non_nullable
as double,pointsValueXAF: null == pointsValueXAF ? _self.pointsValueXAF : pointsValueXAF // ignore: cast_nullable_to_non_nullable
as double,welcomeBonus: null == welcomeBonus ? _self.welcomeBonus : welcomeBonus // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyConfig].
extension LoyaltyConfigPatterns on LoyaltyConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyConfig value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled, @JsonKey(name: 'points_per_xaf')  double pointsPerXAF, @JsonKey(name: 'points_value_xaf')  double pointsValueXAF, @JsonKey(name: 'welcome_bonus')  int welcomeBonus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoyaltyConfig() when $default != null:
return $default(_that.enabled,_that.pointsPerXAF,_that.pointsValueXAF,_that.welcomeBonus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled, @JsonKey(name: 'points_per_xaf')  double pointsPerXAF, @JsonKey(name: 'points_value_xaf')  double pointsValueXAF, @JsonKey(name: 'welcome_bonus')  int welcomeBonus)  $default,) {final _that = this;
switch (_that) {
case _LoyaltyConfig():
return $default(_that.enabled,_that.pointsPerXAF,_that.pointsValueXAF,_that.welcomeBonus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled, @JsonKey(name: 'points_per_xaf')  double pointsPerXAF, @JsonKey(name: 'points_value_xaf')  double pointsValueXAF, @JsonKey(name: 'welcome_bonus')  int welcomeBonus)?  $default,) {final _that = this;
switch (_that) {
case _LoyaltyConfig() when $default != null:
return $default(_that.enabled,_that.pointsPerXAF,_that.pointsValueXAF,_that.welcomeBonus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoyaltyConfig implements LoyaltyConfig {
  const _LoyaltyConfig({this.enabled = false, @JsonKey(name: 'points_per_xaf') this.pointsPerXAF = 1.0, @JsonKey(name: 'points_value_xaf') this.pointsValueXAF = 1.0, @JsonKey(name: 'welcome_bonus') this.welcomeBonus = 100});
  factory _LoyaltyConfig.fromJson(Map<String, dynamic> json) => _$LoyaltyConfigFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey(name: 'points_per_xaf') final  double pointsPerXAF;
@override@JsonKey(name: 'points_value_xaf') final  double pointsValueXAF;
@override@JsonKey(name: 'welcome_bonus') final  int welcomeBonus;

/// Create a copy of LoyaltyConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyConfigCopyWith<_LoyaltyConfig> get copyWith => __$LoyaltyConfigCopyWithImpl<_LoyaltyConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoyaltyConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.pointsPerXAF, pointsPerXAF) || other.pointsPerXAF == pointsPerXAF)&&(identical(other.pointsValueXAF, pointsValueXAF) || other.pointsValueXAF == pointsValueXAF)&&(identical(other.welcomeBonus, welcomeBonus) || other.welcomeBonus == welcomeBonus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,pointsPerXAF,pointsValueXAF,welcomeBonus);

@override
String toString() {
  return 'LoyaltyConfig(enabled: $enabled, pointsPerXAF: $pointsPerXAF, pointsValueXAF: $pointsValueXAF, welcomeBonus: $welcomeBonus)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyConfigCopyWith<$Res> implements $LoyaltyConfigCopyWith<$Res> {
  factory _$LoyaltyConfigCopyWith(_LoyaltyConfig value, $Res Function(_LoyaltyConfig) _then) = __$LoyaltyConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled,@JsonKey(name: 'points_per_xaf') double pointsPerXAF,@JsonKey(name: 'points_value_xaf') double pointsValueXAF,@JsonKey(name: 'welcome_bonus') int welcomeBonus
});




}
/// @nodoc
class __$LoyaltyConfigCopyWithImpl<$Res>
    implements _$LoyaltyConfigCopyWith<$Res> {
  __$LoyaltyConfigCopyWithImpl(this._self, this._then);

  final _LoyaltyConfig _self;
  final $Res Function(_LoyaltyConfig) _then;

/// Create a copy of LoyaltyConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? pointsPerXAF = null,Object? pointsValueXAF = null,Object? welcomeBonus = null,}) {
  return _then(_LoyaltyConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,pointsPerXAF: null == pointsPerXAF ? _self.pointsPerXAF : pointsPerXAF // ignore: cast_nullable_to_non_nullable
as double,pointsValueXAF: null == pointsValueXAF ? _self.pointsValueXAF : pointsValueXAF // ignore: cast_nullable_to_non_nullable
as double,welcomeBonus: null == welcomeBonus ? _self.welcomeBonus : welcomeBonus // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

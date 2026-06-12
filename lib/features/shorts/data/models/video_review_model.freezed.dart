// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoReviewModel {

 String get id; String get orderId; String get videoUrl; String? get thumbnailUrl; String? get caption; int get rating; String get status; int get views; int get likesCount; bool get isLiked; Map<String, dynamic>? get restaurant; Map<String, dynamic>? get client; DateTime get createdAt;
/// Create a copy of VideoReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoReviewModelCopyWith<VideoReviewModel> get copyWith => _$VideoReviewModelCopyWithImpl<VideoReviewModel>(this as VideoReviewModel, _$identity);

  /// Serializes this VideoReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.status, status) || other.status == status)&&(identical(other.views, views) || other.views == views)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&const DeepCollectionEquality().equals(other.restaurant, restaurant)&&const DeepCollectionEquality().equals(other.client, client)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,videoUrl,thumbnailUrl,caption,rating,status,views,likesCount,isLiked,const DeepCollectionEquality().hash(restaurant),const DeepCollectionEquality().hash(client),createdAt);

@override
String toString() {
  return 'VideoReviewModel(id: $id, orderId: $orderId, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, rating: $rating, status: $status, views: $views, likesCount: $likesCount, isLiked: $isLiked, restaurant: $restaurant, client: $client, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $VideoReviewModelCopyWith<$Res>  {
  factory $VideoReviewModelCopyWith(VideoReviewModel value, $Res Function(VideoReviewModel) _then) = _$VideoReviewModelCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, String videoUrl, String? thumbnailUrl, String? caption, int rating, String status, int views, int likesCount, bool isLiked, Map<String, dynamic>? restaurant, Map<String, dynamic>? client, DateTime createdAt
});




}
/// @nodoc
class _$VideoReviewModelCopyWithImpl<$Res>
    implements $VideoReviewModelCopyWith<$Res> {
  _$VideoReviewModelCopyWithImpl(this._self, this._then);

  final VideoReviewModel _self;
  final $Res Function(VideoReviewModel) _then;

/// Create a copy of VideoReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? videoUrl = null,Object? thumbnailUrl = freezed,Object? caption = freezed,Object? rating = null,Object? status = null,Object? views = null,Object? likesCount = null,Object? isLiked = null,Object? restaurant = freezed,Object? client = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,restaurant: freezed == restaurant ? _self.restaurant : restaurant // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoReviewModel].
extension VideoReviewModelPatterns on VideoReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _VideoReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideoReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  String videoUrl,  String? thumbnailUrl,  String? caption,  int rating,  String status,  int views,  int likesCount,  bool isLiked,  Map<String, dynamic>? restaurant,  Map<String, dynamic>? client,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoReviewModel() when $default != null:
return $default(_that.id,_that.orderId,_that.videoUrl,_that.thumbnailUrl,_that.caption,_that.rating,_that.status,_that.views,_that.likesCount,_that.isLiked,_that.restaurant,_that.client,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  String videoUrl,  String? thumbnailUrl,  String? caption,  int rating,  String status,  int views,  int likesCount,  bool isLiked,  Map<String, dynamic>? restaurant,  Map<String, dynamic>? client,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _VideoReviewModel():
return $default(_that.id,_that.orderId,_that.videoUrl,_that.thumbnailUrl,_that.caption,_that.rating,_that.status,_that.views,_that.likesCount,_that.isLiked,_that.restaurant,_that.client,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  String videoUrl,  String? thumbnailUrl,  String? caption,  int rating,  String status,  int views,  int likesCount,  bool isLiked,  Map<String, dynamic>? restaurant,  Map<String, dynamic>? client,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _VideoReviewModel() when $default != null:
return $default(_that.id,_that.orderId,_that.videoUrl,_that.thumbnailUrl,_that.caption,_that.rating,_that.status,_that.views,_that.likesCount,_that.isLiked,_that.restaurant,_that.client,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoReviewModel implements VideoReviewModel {
  const _VideoReviewModel({required this.id, required this.orderId, required this.videoUrl, this.thumbnailUrl, this.caption, required this.rating, required this.status, required this.views, required this.likesCount, required this.isLiked, final  Map<String, dynamic>? restaurant, final  Map<String, dynamic>? client, required this.createdAt}): _restaurant = restaurant,_client = client;
  factory _VideoReviewModel.fromJson(Map<String, dynamic> json) => _$VideoReviewModelFromJson(json);

@override final  String id;
@override final  String orderId;
@override final  String videoUrl;
@override final  String? thumbnailUrl;
@override final  String? caption;
@override final  int rating;
@override final  String status;
@override final  int views;
@override final  int likesCount;
@override final  bool isLiked;
 final  Map<String, dynamic>? _restaurant;
@override Map<String, dynamic>? get restaurant {
  final value = _restaurant;
  if (value == null) return null;
  if (_restaurant is EqualUnmodifiableMapView) return _restaurant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _client;
@override Map<String, dynamic>? get client {
  final value = _client;
  if (value == null) return null;
  if (_client is EqualUnmodifiableMapView) return _client;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;

/// Create a copy of VideoReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoReviewModelCopyWith<_VideoReviewModel> get copyWith => __$VideoReviewModelCopyWithImpl<_VideoReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.status, status) || other.status == status)&&(identical(other.views, views) || other.views == views)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&const DeepCollectionEquality().equals(other._restaurant, _restaurant)&&const DeepCollectionEquality().equals(other._client, _client)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,videoUrl,thumbnailUrl,caption,rating,status,views,likesCount,isLiked,const DeepCollectionEquality().hash(_restaurant),const DeepCollectionEquality().hash(_client),createdAt);

@override
String toString() {
  return 'VideoReviewModel(id: $id, orderId: $orderId, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, rating: $rating, status: $status, views: $views, likesCount: $likesCount, isLiked: $isLiked, restaurant: $restaurant, client: $client, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$VideoReviewModelCopyWith<$Res> implements $VideoReviewModelCopyWith<$Res> {
  factory _$VideoReviewModelCopyWith(_VideoReviewModel value, $Res Function(_VideoReviewModel) _then) = __$VideoReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, String videoUrl, String? thumbnailUrl, String? caption, int rating, String status, int views, int likesCount, bool isLiked, Map<String, dynamic>? restaurant, Map<String, dynamic>? client, DateTime createdAt
});




}
/// @nodoc
class __$VideoReviewModelCopyWithImpl<$Res>
    implements _$VideoReviewModelCopyWith<$Res> {
  __$VideoReviewModelCopyWithImpl(this._self, this._then);

  final _VideoReviewModel _self;
  final $Res Function(_VideoReviewModel) _then;

/// Create a copy of VideoReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? videoUrl = null,Object? thumbnailUrl = freezed,Object? caption = freezed,Object? rating = null,Object? status = null,Object? views = null,Object? likesCount = null,Object? isLiked = null,Object? restaurant = freezed,Object? client = freezed,Object? createdAt = null,}) {
  return _then(_VideoReviewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,restaurant: freezed == restaurant ? _self._restaurant : restaurant // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,client: freezed == client ? _self._client : client // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

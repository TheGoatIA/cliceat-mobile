// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NavigationState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NavigationState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NavigationState()';
}


}

/// @nodoc
class $NavigationStateCopyWith<$Res>  {
$NavigationStateCopyWith(NavigationState _, $Res Function(NavigationState) __);
}


/// Adds pattern-matching-related methods to [NavigationState].
extension NavigationStatePatterns on NavigationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NavigationIdle value)?  idle,TResult Function( NavigationLoading value)?  loading,TResult Function( NavigationNavigating value)?  navigating,TResult Function( NavigationArrived value)?  arrived,TResult Function( NavigationError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NavigationIdle() when idle != null:
return idle(_that);case NavigationLoading() when loading != null:
return loading(_that);case NavigationNavigating() when navigating != null:
return navigating(_that);case NavigationArrived() when arrived != null:
return arrived(_that);case NavigationError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NavigationIdle value)  idle,required TResult Function( NavigationLoading value)  loading,required TResult Function( NavigationNavigating value)  navigating,required TResult Function( NavigationArrived value)  arrived,required TResult Function( NavigationError value)  error,}){
final _that = this;
switch (_that) {
case NavigationIdle():
return idle(_that);case NavigationLoading():
return loading(_that);case NavigationNavigating():
return navigating(_that);case NavigationArrived():
return arrived(_that);case NavigationError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NavigationIdle value)?  idle,TResult? Function( NavigationLoading value)?  loading,TResult? Function( NavigationNavigating value)?  navigating,TResult? Function( NavigationArrived value)?  arrived,TResult? Function( NavigationError value)?  error,}){
final _that = this;
switch (_that) {
case NavigationIdle() when idle != null:
return idle(_that);case NavigationLoading() when loading != null:
return loading(_that);case NavigationNavigating() when navigating != null:
return navigating(_that);case NavigationArrived() when arrived != null:
return arrived(_that);case NavigationError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  loading,TResult Function( OsrmRoute route,  int currentStepIndex,  double currentLat,  double currentLng,  bool isRerouting)?  navigating,TResult Function( OsrmRoute route)?  arrived,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NavigationIdle() when idle != null:
return idle();case NavigationLoading() when loading != null:
return loading();case NavigationNavigating() when navigating != null:
return navigating(_that.route,_that.currentStepIndex,_that.currentLat,_that.currentLng,_that.isRerouting);case NavigationArrived() when arrived != null:
return arrived(_that.route);case NavigationError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  loading,required TResult Function( OsrmRoute route,  int currentStepIndex,  double currentLat,  double currentLng,  bool isRerouting)  navigating,required TResult Function( OsrmRoute route)  arrived,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case NavigationIdle():
return idle();case NavigationLoading():
return loading();case NavigationNavigating():
return navigating(_that.route,_that.currentStepIndex,_that.currentLat,_that.currentLng,_that.isRerouting);case NavigationArrived():
return arrived(_that.route);case NavigationError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  loading,TResult? Function( OsrmRoute route,  int currentStepIndex,  double currentLat,  double currentLng,  bool isRerouting)?  navigating,TResult? Function( OsrmRoute route)?  arrived,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case NavigationIdle() when idle != null:
return idle();case NavigationLoading() when loading != null:
return loading();case NavigationNavigating() when navigating != null:
return navigating(_that.route,_that.currentStepIndex,_that.currentLat,_that.currentLng,_that.isRerouting);case NavigationArrived() when arrived != null:
return arrived(_that.route);case NavigationError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NavigationIdle with DiagnosticableTreeMixin implements NavigationState {
  const NavigationIdle();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NavigationState.idle'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NavigationState.idle()';
}


}




/// @nodoc


class NavigationLoading with DiagnosticableTreeMixin implements NavigationState {
  const NavigationLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NavigationState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NavigationState.loading()';
}


}




/// @nodoc


class NavigationNavigating with DiagnosticableTreeMixin implements NavigationState {
  const NavigationNavigating({required this.route, required this.currentStepIndex, required this.currentLat, required this.currentLng, this.isRerouting = false});
  

 final  OsrmRoute route;
 final  int currentStepIndex;
 final  double currentLat;
 final  double currentLng;
@JsonKey() final  bool isRerouting;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationNavigatingCopyWith<NavigationNavigating> get copyWith => _$NavigationNavigatingCopyWithImpl<NavigationNavigating>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NavigationState.navigating'))
    ..add(DiagnosticsProperty('route', route))..add(DiagnosticsProperty('currentStepIndex', currentStepIndex))..add(DiagnosticsProperty('currentLat', currentLat))..add(DiagnosticsProperty('currentLng', currentLng))..add(DiagnosticsProperty('isRerouting', isRerouting));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationNavigating&&(identical(other.route, route) || other.route == route)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.currentLat, currentLat) || other.currentLat == currentLat)&&(identical(other.currentLng, currentLng) || other.currentLng == currentLng)&&(identical(other.isRerouting, isRerouting) || other.isRerouting == isRerouting));
}


@override
int get hashCode => Object.hash(runtimeType,route,currentStepIndex,currentLat,currentLng,isRerouting);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NavigationState.navigating(route: $route, currentStepIndex: $currentStepIndex, currentLat: $currentLat, currentLng: $currentLng, isRerouting: $isRerouting)';
}


}

/// @nodoc
abstract mixin class $NavigationNavigatingCopyWith<$Res> implements $NavigationStateCopyWith<$Res> {
  factory $NavigationNavigatingCopyWith(NavigationNavigating value, $Res Function(NavigationNavigating) _then) = _$NavigationNavigatingCopyWithImpl;
@useResult
$Res call({
 OsrmRoute route, int currentStepIndex, double currentLat, double currentLng, bool isRerouting
});




}
/// @nodoc
class _$NavigationNavigatingCopyWithImpl<$Res>
    implements $NavigationNavigatingCopyWith<$Res> {
  _$NavigationNavigatingCopyWithImpl(this._self, this._then);

  final NavigationNavigating _self;
  final $Res Function(NavigationNavigating) _then;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? route = null,Object? currentStepIndex = null,Object? currentLat = null,Object? currentLng = null,Object? isRerouting = null,}) {
  return _then(NavigationNavigating(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as OsrmRoute,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,currentLat: null == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as double,currentLng: null == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as double,isRerouting: null == isRerouting ? _self.isRerouting : isRerouting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class NavigationArrived with DiagnosticableTreeMixin implements NavigationState {
  const NavigationArrived({required this.route});
  

 final  OsrmRoute route;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationArrivedCopyWith<NavigationArrived> get copyWith => _$NavigationArrivedCopyWithImpl<NavigationArrived>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NavigationState.arrived'))
    ..add(DiagnosticsProperty('route', route));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationArrived&&(identical(other.route, route) || other.route == route));
}


@override
int get hashCode => Object.hash(runtimeType,route);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NavigationState.arrived(route: $route)';
}


}

/// @nodoc
abstract mixin class $NavigationArrivedCopyWith<$Res> implements $NavigationStateCopyWith<$Res> {
  factory $NavigationArrivedCopyWith(NavigationArrived value, $Res Function(NavigationArrived) _then) = _$NavigationArrivedCopyWithImpl;
@useResult
$Res call({
 OsrmRoute route
});




}
/// @nodoc
class _$NavigationArrivedCopyWithImpl<$Res>
    implements $NavigationArrivedCopyWith<$Res> {
  _$NavigationArrivedCopyWithImpl(this._self, this._then);

  final NavigationArrived _self;
  final $Res Function(NavigationArrived) _then;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? route = null,}) {
  return _then(NavigationArrived(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as OsrmRoute,
  ));
}


}

/// @nodoc


class NavigationError with DiagnosticableTreeMixin implements NavigationState {
  const NavigationError(this.message);
  

 final  String message;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationErrorCopyWith<NavigationError> get copyWith => _$NavigationErrorCopyWithImpl<NavigationError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NavigationState.error'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NavigationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NavigationErrorCopyWith<$Res> implements $NavigationStateCopyWith<$Res> {
  factory $NavigationErrorCopyWith(NavigationError value, $Res Function(NavigationError) _then) = _$NavigationErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NavigationErrorCopyWithImpl<$Res>
    implements $NavigationErrorCopyWith<$Res> {
  _$NavigationErrorCopyWithImpl(this._self, this._then);

  final NavigationError _self;
  final $Res Function(NavigationError) _then;

/// Create a copy of NavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NavigationError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

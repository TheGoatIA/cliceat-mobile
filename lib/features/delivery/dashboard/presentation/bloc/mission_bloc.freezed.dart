// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MissionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MissionEvent()';
}


}

/// @nodoc
class $MissionEventCopyWith<$Res>  {
$MissionEventCopyWith(MissionEvent _, $Res Function(MissionEvent) __);
}


/// Adds pattern-matching-related methods to [MissionEvent].
extension MissionEventPatterns on MissionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _LoadActiveMissions value)?  loadActiveMissions,TResult Function( _AcceptMission value)?  acceptMission,TResult Function( _RejectMission value)?  rejectMission,TResult Function( _UpdateStatus value)?  updateStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _LoadActiveMissions() when loadActiveMissions != null:
return loadActiveMissions(_that);case _AcceptMission() when acceptMission != null:
return acceptMission(_that);case _RejectMission() when rejectMission != null:
return rejectMission(_that);case _UpdateStatus() when updateStatus != null:
return updateStatus(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _LoadActiveMissions value)  loadActiveMissions,required TResult Function( _AcceptMission value)  acceptMission,required TResult Function( _RejectMission value)  rejectMission,required TResult Function( _UpdateStatus value)  updateStatus,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _LoadActiveMissions():
return loadActiveMissions(_that);case _AcceptMission():
return acceptMission(_that);case _RejectMission():
return rejectMission(_that);case _UpdateStatus():
return updateStatus(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _LoadActiveMissions value)?  loadActiveMissions,TResult? Function( _AcceptMission value)?  acceptMission,TResult? Function( _RejectMission value)?  rejectMission,TResult? Function( _UpdateStatus value)?  updateStatus,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _LoadActiveMissions() when loadActiveMissions != null:
return loadActiveMissions(_that);case _AcceptMission() when acceptMission != null:
return acceptMission(_that);case _RejectMission() when rejectMission != null:
return rejectMission(_that);case _UpdateStatus() when updateStatus != null:
return updateStatus(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  loadActiveMissions,TResult Function( String missionId)?  acceptMission,TResult Function( String missionId)?  rejectMission,TResult Function( String missionId,  String status)?  updateStatus,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _LoadActiveMissions() when loadActiveMissions != null:
return loadActiveMissions();case _AcceptMission() when acceptMission != null:
return acceptMission(_that.missionId);case _RejectMission() when rejectMission != null:
return rejectMission(_that.missionId);case _UpdateStatus() when updateStatus != null:
return updateStatus(_that.missionId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  loadActiveMissions,required TResult Function( String missionId)  acceptMission,required TResult Function( String missionId)  rejectMission,required TResult Function( String missionId,  String status)  updateStatus,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _LoadActiveMissions():
return loadActiveMissions();case _AcceptMission():
return acceptMission(_that.missionId);case _RejectMission():
return rejectMission(_that.missionId);case _UpdateStatus():
return updateStatus(_that.missionId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  loadActiveMissions,TResult? Function( String missionId)?  acceptMission,TResult? Function( String missionId)?  rejectMission,TResult? Function( String missionId,  String status)?  updateStatus,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _LoadActiveMissions() when loadActiveMissions != null:
return loadActiveMissions();case _AcceptMission() when acceptMission != null:
return acceptMission(_that.missionId);case _RejectMission() when rejectMission != null:
return rejectMission(_that.missionId);case _UpdateStatus() when updateStatus != null:
return updateStatus(_that.missionId,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements MissionEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MissionEvent.started()';
}


}




/// @nodoc


class _LoadActiveMissions implements MissionEvent {
  const _LoadActiveMissions();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadActiveMissions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MissionEvent.loadActiveMissions()';
}


}




/// @nodoc


class _AcceptMission implements MissionEvent {
  const _AcceptMission(this.missionId);
  

 final  String missionId;

/// Create a copy of MissionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcceptMissionCopyWith<_AcceptMission> get copyWith => __$AcceptMissionCopyWithImpl<_AcceptMission>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcceptMission&&(identical(other.missionId, missionId) || other.missionId == missionId));
}


@override
int get hashCode => Object.hash(runtimeType,missionId);

@override
String toString() {
  return 'MissionEvent.acceptMission(missionId: $missionId)';
}


}

/// @nodoc
abstract mixin class _$AcceptMissionCopyWith<$Res> implements $MissionEventCopyWith<$Res> {
  factory _$AcceptMissionCopyWith(_AcceptMission value, $Res Function(_AcceptMission) _then) = __$AcceptMissionCopyWithImpl;
@useResult
$Res call({
 String missionId
});




}
/// @nodoc
class __$AcceptMissionCopyWithImpl<$Res>
    implements _$AcceptMissionCopyWith<$Res> {
  __$AcceptMissionCopyWithImpl(this._self, this._then);

  final _AcceptMission _self;
  final $Res Function(_AcceptMission) _then;

/// Create a copy of MissionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? missionId = null,}) {
  return _then(_AcceptMission(
null == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RejectMission implements MissionEvent {
  const _RejectMission(this.missionId);
  

 final  String missionId;

/// Create a copy of MissionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RejectMissionCopyWith<_RejectMission> get copyWith => __$RejectMissionCopyWithImpl<_RejectMission>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectMission&&(identical(other.missionId, missionId) || other.missionId == missionId));
}


@override
int get hashCode => Object.hash(runtimeType,missionId);

@override
String toString() {
  return 'MissionEvent.rejectMission(missionId: $missionId)';
}


}

/// @nodoc
abstract mixin class _$RejectMissionCopyWith<$Res> implements $MissionEventCopyWith<$Res> {
  factory _$RejectMissionCopyWith(_RejectMission value, $Res Function(_RejectMission) _then) = __$RejectMissionCopyWithImpl;
@useResult
$Res call({
 String missionId
});




}
/// @nodoc
class __$RejectMissionCopyWithImpl<$Res>
    implements _$RejectMissionCopyWith<$Res> {
  __$RejectMissionCopyWithImpl(this._self, this._then);

  final _RejectMission _self;
  final $Res Function(_RejectMission) _then;

/// Create a copy of MissionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? missionId = null,}) {
  return _then(_RejectMission(
null == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateStatus implements MissionEvent {
  const _UpdateStatus(this.missionId, this.status);
  

 final  String missionId;
 final  String status;

/// Create a copy of MissionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateStatusCopyWith<_UpdateStatus> get copyWith => __$UpdateStatusCopyWithImpl<_UpdateStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateStatus&&(identical(other.missionId, missionId) || other.missionId == missionId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,missionId,status);

@override
String toString() {
  return 'MissionEvent.updateStatus(missionId: $missionId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateStatusCopyWith<$Res> implements $MissionEventCopyWith<$Res> {
  factory _$UpdateStatusCopyWith(_UpdateStatus value, $Res Function(_UpdateStatus) _then) = __$UpdateStatusCopyWithImpl;
@useResult
$Res call({
 String missionId, String status
});




}
/// @nodoc
class __$UpdateStatusCopyWithImpl<$Res>
    implements _$UpdateStatusCopyWith<$Res> {
  __$UpdateStatusCopyWithImpl(this._self, this._then);

  final _UpdateStatus _self;
  final $Res Function(_UpdateStatus) _then;

/// Create a copy of MissionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? missionId = null,Object? status = null,}) {
  return _then(_UpdateStatus(
null == missionId ? _self.missionId : missionId // ignore: cast_nullable_to_non_nullable
as String,null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MissionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MissionState()';
}


}

/// @nodoc
class $MissionStateCopyWith<$Res>  {
$MissionStateCopyWith(MissionState _, $Res Function(MissionState) __);
}


/// Adds pattern-matching-related methods to [MissionState].
extension MissionStatePatterns on MissionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _ActionSuccess():
return actionSuccess(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Map<String, dynamic>> missions)?  loaded,TResult Function( String message)?  actionSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.missions);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Map<String, dynamic>> missions)  loaded,required TResult Function( String message)  actionSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.missions);case _ActionSuccess():
return actionSuccess(_that.message);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Map<String, dynamic>> missions)?  loaded,TResult? Function( String message)?  actionSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.missions);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements MissionState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MissionState.initial()';
}


}




/// @nodoc


class _Loading implements MissionState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MissionState.loading()';
}


}




/// @nodoc


class _Loaded implements MissionState {
  const _Loaded(final  List<Map<String, dynamic>> missions): _missions = missions;
  

 final  List<Map<String, dynamic>> _missions;
 List<Map<String, dynamic>> get missions {
  if (_missions is EqualUnmodifiableListView) return _missions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missions);
}


/// Create a copy of MissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._missions, _missions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_missions));

@override
String toString() {
  return 'MissionState.loaded(missions: $missions)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $MissionStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> missions
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of MissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? missions = null,}) {
  return _then(_Loaded(
null == missions ? _self._missions : missions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

/// @nodoc


class _ActionSuccess implements MissionState {
  const _ActionSuccess(this.message);
  

 final  String message;

/// Create a copy of MissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionSuccessCopyWith<_ActionSuccess> get copyWith => __$ActionSuccessCopyWithImpl<_ActionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MissionState.actionSuccess(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $MissionStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of MissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActionSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements MissionState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of MissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MissionState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $MissionStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of MissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

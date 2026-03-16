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

// ─── MissionEvent ────────────────────────────────────────────────────────────

mixin _$MissionEvent {}

extension MissionEventPatterns on MissionEvent {
  @optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function(_Started value)? started,TResult Function(_LoadActiveMissions value)? loadActiveMissions,TResult Function(_AcceptMission value)? acceptMission,TResult Function(_RejectMission value)? rejectMission,TResult Function(_UpdateStatus value)? updateStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null: return started(_that);
case _LoadActiveMissions() when loadActiveMissions != null: return loadActiveMissions(_that);
case _AcceptMission() when acceptMission != null: return acceptMission(_that);
case _RejectMission() when rejectMission != null: return rejectMission(_that);
case _UpdateStatus() when updateStatus != null: return updateStatus(_that);
case _: return orElse();
}
}

  @optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function(_Started value) started,required TResult Function(_LoadActiveMissions value) loadActiveMissions,required TResult Function(_AcceptMission value) acceptMission,required TResult Function(_RejectMission value) rejectMission,required TResult Function(_UpdateStatus value) updateStatus,}){
final _that = this;
switch (_that) {
case _Started(): return started(_that);
case _LoadActiveMissions(): return loadActiveMissions(_that);
case _AcceptMission(): return acceptMission(_that);
case _RejectMission(): return rejectMission(_that);
case _UpdateStatus(): return updateStatus(_that);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function(_Started value)? started,TResult? Function(_LoadActiveMissions value)? loadActiveMissions,TResult? Function(_AcceptMission value)? acceptMission,TResult? Function(_RejectMission value)? rejectMission,TResult? Function(_UpdateStatus value)? updateStatus,}){
final _that = this;
switch (_that) {
case _Started() when started != null: return started(_that);
case _LoadActiveMissions() when loadActiveMissions != null: return loadActiveMissions(_that);
case _AcceptMission() when acceptMission != null: return acceptMission(_that);
case _RejectMission() when rejectMission != null: return rejectMission(_that);
case _UpdateStatus() when updateStatus != null: return updateStatus(_that);
case _: return null;
}
}

  @optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()? started,TResult Function()? loadActiveMissions,TResult Function(String missionId)? acceptMission,TResult Function(String missionId)? rejectMission,TResult Function(String missionId, String status)? updateStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null: return started();
case _LoadActiveMissions() when loadActiveMissions != null: return loadActiveMissions();
case _AcceptMission() when acceptMission != null: return acceptMission(_that.missionId);
case _RejectMission() when rejectMission != null: return rejectMission(_that.missionId);
case _UpdateStatus() when updateStatus != null: return updateStatus(_that.missionId, _that.status);
case _: return orElse();
}
}

  @optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function() started,required TResult Function() loadActiveMissions,required TResult Function(String missionId) acceptMission,required TResult Function(String missionId) rejectMission,required TResult Function(String missionId, String status) updateStatus,}){
final _that = this;
switch (_that) {
case _Started(): return started();
case _LoadActiveMissions(): return loadActiveMissions();
case _AcceptMission(): return acceptMission(_that.missionId);
case _RejectMission(): return rejectMission(_that.missionId);
case _UpdateStatus(): return updateStatus(_that.missionId, _that.status);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()? started,TResult? Function()? loadActiveMissions,TResult? Function(String missionId)? acceptMission,TResult? Function(String missionId)? rejectMission,TResult? Function(String missionId, String status)? updateStatus,}){
final _that = this;
switch (_that) {
case _Started() when started != null: return started();
case _LoadActiveMissions() when loadActiveMissions != null: return loadActiveMissions();
case _AcceptMission() when acceptMission != null: return acceptMission(_that.missionId);
case _RejectMission() when rejectMission != null: return rejectMission(_that.missionId);
case _UpdateStatus() when updateStatus != null: return updateStatus(_that.missionId, _that.status);
case _: return null;
}
}
}

class _Started implements MissionEvent {
  const _Started();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Started);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'MissionEvent.started()';
}

class _LoadActiveMissions implements MissionEvent {
  const _LoadActiveMissions();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _LoadActiveMissions);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'MissionEvent.loadActiveMissions()';
}

class _AcceptMission implements MissionEvent {
  const _AcceptMission(this.missionId);
  final String missionId;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _AcceptMission && other.missionId == missionId);
  @override int get hashCode => Object.hash(runtimeType, missionId);
  @override String toString() => 'MissionEvent.acceptMission(missionId: $missionId)';
}

class _RejectMission implements MissionEvent {
  const _RejectMission(this.missionId);
  final String missionId;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _RejectMission && other.missionId == missionId);
  @override int get hashCode => Object.hash(runtimeType, missionId);
  @override String toString() => 'MissionEvent.rejectMission(missionId: $missionId)';
}

class _UpdateStatus implements MissionEvent {
  const _UpdateStatus(this.missionId, this.status);
  final String missionId;
  final String status;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _UpdateStatus && other.missionId == missionId && other.status == status);
  @override int get hashCode => Object.hash(runtimeType, missionId, status);
  @override String toString() => 'MissionEvent.updateStatus(missionId: $missionId, status: $status)';
}

// ─── MissionState ────────────────────────────────────────────────────────────

mixin _$MissionState {}

extension MissionStatePatterns on MissionState {
  @optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function(_Initial value)? initial,TResult Function(_Loading value)? loading,TResult Function(_Loaded value)? loaded,TResult Function(_Error value)? error,TResult Function(_ActionSuccess value)? actionSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial(_that);
case _Loading() when loading != null: return loading(_that);
case _Loaded() when loaded != null: return loaded(_that);
case _Error() when error != null: return error(_that);
case _ActionSuccess() when actionSuccess != null: return actionSuccess(_that);
case _: return orElse();
}
}

  @optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function(_Initial value) initial,required TResult Function(_Loading value) loading,required TResult Function(_Loaded value) loaded,required TResult Function(_Error value) error,required TResult Function(_ActionSuccess value) actionSuccess,}){
final _that = this;
switch (_that) {
case _Initial(): return initial(_that);
case _Loading(): return loading(_that);
case _Loaded(): return loaded(_that);
case _Error(): return error(_that);
case _ActionSuccess(): return actionSuccess(_that);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function(_Initial value)? initial,TResult? Function(_Loading value)? loading,TResult? Function(_Loaded value)? loaded,TResult? Function(_Error value)? error,TResult? Function(_ActionSuccess value)? actionSuccess,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial(_that);
case _Loading() when loading != null: return loading(_that);
case _Loaded() when loaded != null: return loaded(_that);
case _Error() when error != null: return error(_that);
case _ActionSuccess() when actionSuccess != null: return actionSuccess(_that);
case _: return null;
}
}

  @optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()? initial,TResult Function()? loading,TResult Function(List<Map<String, dynamic>> missions)? loaded,TResult Function(String message)? error,TResult Function(String message)? actionSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial();
case _Loading() when loading != null: return loading();
case _Loaded() when loaded != null: return loaded(_that.missions);
case _Error() when error != null: return error(_that.message);
case _ActionSuccess() when actionSuccess != null: return actionSuccess(_that.message);
case _: return orElse();
}
}

  @optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function() initial,required TResult Function() loading,required TResult Function(List<Map<String, dynamic>> missions) loaded,required TResult Function(String message) error,required TResult Function(String message) actionSuccess,}){
final _that = this;
switch (_that) {
case _Initial(): return initial();
case _Loading(): return loading();
case _Loaded(): return loaded(_that.missions);
case _Error(): return error(_that.message);
case _ActionSuccess(): return actionSuccess(_that.message);
case _: throw StateError('Unexpected subclass');
}
}

  @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()? initial,TResult? Function()? loading,TResult? Function(List<Map<String, dynamic>> missions)? loaded,TResult? Function(String message)? error,TResult? Function(String message)? actionSuccess,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null: return initial();
case _Loading() when loading != null: return loading();
case _Loaded() when loaded != null: return loaded(_that.missions);
case _Error() when error != null: return error(_that.message);
case _ActionSuccess() when actionSuccess != null: return actionSuccess(_that.message);
case _: return null;
}
}
}

class _Initial implements MissionState {
  const _Initial();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Initial);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'MissionState.initial()';
}

class _Loading implements MissionState {
  const _Loading();
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Loading);
  @override int get hashCode => runtimeType.hashCode;
  @override String toString() => 'MissionState.loading()';
}

class _Loaded implements MissionState {
  const _Loaded(this.missions);
  final List<Map<String, dynamic>> missions;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Loaded && other.missions == missions);
  @override int get hashCode => Object.hash(runtimeType, missions);
  @override String toString() => 'MissionState.loaded(missions: $missions)';
}

class _Error implements MissionState {
  const _Error(this.message);
  final String message;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _Error && other.message == message);
  @override int get hashCode => Object.hash(runtimeType, message);
  @override String toString() => 'MissionState.error(message: $message)';
}

class _ActionSuccess implements MissionState {
  const _ActionSuccess(this.message);
  final String message;
  @override bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is _ActionSuccess && other.message == message);
  @override int get hashCode => Object.hash(runtimeType, message);
  @override String toString() => 'MissionState.actionSuccess(message: $message)';
}

// dart format on

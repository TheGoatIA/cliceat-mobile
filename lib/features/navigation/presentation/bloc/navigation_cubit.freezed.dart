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
mixin _$NavigationState {

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType && other is NavigationState);
}

@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NavigationState()';
}
}

/// @nodoc
class $NavigationStateCopyWith<$Res> {
  $NavigationStateCopyWith(NavigationState _, $Res Function(NavigationState) __);
}

/// Adds pattern-matching-related methods to [NavigationState].
extension NavigationStatePatterns on NavigationState {
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(OsrmRoute route, int currentStepIndex, double currentLat, double currentLng, bool isRerouting)? navigating,
    TResult Function(OsrmRoute route)? arrived,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null: return idle();
      case _Loading() when loading != null: return loading();
      case _Navigating() when navigating != null:
        return navigating(_that.route, _that.currentStepIndex, _that.currentLat, _that.currentLng, _that.isRerouting);
      case _Arrived() when arrived != null: return arrived(_that.route);
      case _Error() when error != null: return error(_that.message);
      case _: return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(OsrmRoute route, int currentStepIndex, double currentLat, double currentLng, bool isRerouting) navigating,
    required TResult Function(OsrmRoute route) arrived,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle(): return idle();
      case _Loading(): return loading();
      case _Navigating():
        return navigating(_that.route, _that.currentStepIndex, _that.currentLat, _that.currentLng, _that.isRerouting);
      case _Arrived(): return arrived(_that.route);
      case _Error(): return error(_that.message);
      case _: throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(OsrmRoute route, int currentStepIndex, double currentLat, double currentLng, bool isRerouting)? navigating,
    TResult? Function(OsrmRoute route)? arrived,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null: return idle();
      case _Loading() when loading != null: return loading();
      case _Navigating() when navigating != null:
        return navigating(_that.route, _that.currentStepIndex, _that.currentLat, _that.currentLng, _that.isRerouting);
      case _Arrived() when arrived != null: return arrived(_that.route);
      case _Error() when error != null: return error(_that.message);
      case _: return null;
    }
  }

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Loading value)? loading,
    TResult Function(_Navigating value)? navigating,
    TResult Function(_Arrived value)? arrived,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null: return idle(_that);
      case _Loading() when loading != null: return loading(_that);
      case _Navigating() when navigating != null: return navigating(_that);
      case _Arrived() when arrived != null: return arrived(_that);
      case _Error() when error != null: return error(_that);
      case _: return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Navigating value) navigating,
    required TResult Function(_Arrived value) arrived,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle(): return idle(_that);
      case _Loading(): return loading(_that);
      case _Navigating(): return navigating(_that);
      case _Arrived(): return arrived(_that);
      case _Error(): return error(_that);
      case _: throw StateError('Unexpected subclass');
    }
  }
}

/// @nodoc
class _Idle implements NavigationState {
  const _Idle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _Idle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'NavigationState.idle()';
}

/// @nodoc
class _Loading implements NavigationState {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'NavigationState.loading()';
}

/// @nodoc
class _Navigating implements NavigationState {
  const _Navigating({
    required this.route,
    required this.currentStepIndex,
    required this.currentLat,
    required this.currentLng,
    this.isRerouting = false,
  });

  final OsrmRoute route;
  final int currentStepIndex;
  final double currentLat;
  final double currentLng;
  final bool isRerouting;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Navigating &&
            other.route == route &&
            other.currentStepIndex == currentStepIndex &&
            other.currentLat == currentLat &&
            other.currentLng == currentLng &&
            other.isRerouting == isRerouting);
  }

  @override
  int get hashCode => Object.hash(runtimeType, route, currentStepIndex, currentLat, currentLng, isRerouting);

  @override
  String toString() =>
      'NavigationState.navigating(route: $route, currentStepIndex: $currentStepIndex, currentLat: $currentLat, currentLng: $currentLng, isRerouting: $isRerouting)';
}

/// @nodoc
class _Arrived implements NavigationState {
  const _Arrived({required this.route});

  final OsrmRoute route;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Arrived && other.route == route);
  }

  @override
  int get hashCode => Object.hash(runtimeType, route);

  @override
  String toString() => 'NavigationState.arrived(route: $route)';
}

/// @nodoc
class _Error implements NavigationState {
  const _Error(this.message);

  final String message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Error && other.message == message);
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => 'NavigationState.error(message: $message)';
}

// dart format on

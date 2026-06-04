part of 'mission_bloc.dart';

abstract class MissionState {
  const MissionState();

  const factory MissionState.initial() = _Initial;
  const factory MissionState.loading() = _Loading;
  const factory MissionState.loaded(List<Map<String, dynamic>> missions) =
      _Loaded;
  const factory MissionState.error(String message) = _Error;
  const factory MissionState.actionSuccess(String message) = _ActionSuccess;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List<Map<String, dynamic>> missions)? loaded,
    T Function(String message)? error,
    T Function(String message)? actionSuccess,
    required T Function() orElse,
  }) {
    if (this is _Initial && initial != null) {
      return initial();
    }
    if (this is _Loading && loading != null) {
      return loading();
    }
    if (this is _Loaded && loaded != null) {
      return loaded((this as _Loaded).missions);
    }
    if (this is _Error && error != null) {
      return error((this as _Error).message);
    }
    if (this is _ActionSuccess && actionSuccess != null) {
      return actionSuccess((this as _ActionSuccess).message);
    }
    return orElse();
  }
}

class _Initial extends MissionState {
  const _Initial();
}

class _Loading extends MissionState {
  const _Loading();
}

class _Loaded extends MissionState {
  final List<Map<String, dynamic>> missions;
  const _Loaded(this.missions);
}

class _Error extends MissionState {
  final String message;
  const _Error(this.message);
}

class _ActionSuccess extends MissionState {
  final String message;
  const _ActionSuccess(this.message);
}

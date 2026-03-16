part of 'mission_bloc.dart';

@freezed
class MissionState with _$MissionState {
  const factory MissionState.initial() = _Initial;
  const factory MissionState.loading() = _Loading;
  const factory MissionState.loaded(List<Map<String, dynamic>> missions) = _Loaded;
  const factory MissionState.actionSuccess(String message) = _ActionSuccess;
  const factory MissionState.error(String message) = _Error;
}

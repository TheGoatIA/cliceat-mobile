part of 'mission_bloc.dart';

@freezed
class MissionState with _$MissionState {
  const factory MissionState.initial() = _Initial;
  const factory MissionState.loading() = _Loading;
  const factory MissionState.loaded(List<Map<String, dynamic>> missions) = _Loaded;
<<<<<<< HEAD
  const factory MissionState.error(String message) = _Error;
  const factory MissionState.actionSuccess(String message) = _ActionSuccess;
=======
  const factory MissionState.actionSuccess(String message) = _ActionSuccess;
  const factory MissionState.error(String message) = _Error;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

part of 'mission_bloc.dart';

@freezed
class MissionEvent with _$MissionEvent {
  const factory MissionEvent.started() = _Started;
  const factory MissionEvent.loadActiveMissions() = _LoadActiveMissions;
  const factory MissionEvent.acceptMission(String missionId) = _AcceptMission;
  const factory MissionEvent.rejectMission(String missionId) = _RejectMission;
<<<<<<< HEAD
  const factory MissionEvent.updateStatus(
    String missionId,
    String status, {
    @Default({}) Map<String, dynamic> metadata,
  }) = _UpdateStatus;
=======
  const factory MissionEvent.updateStatus(String missionId, String status) = _UpdateStatus;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

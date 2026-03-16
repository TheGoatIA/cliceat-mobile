part of 'mission_bloc.dart';

@freezed
class MissionEvent with _$MissionEvent {
  const factory MissionEvent.started() = _Started;
  const factory MissionEvent.loadActiveMissions() = _LoadActiveMissions;
  const factory MissionEvent.acceptMission(String missionId) = _AcceptMission;
  const factory MissionEvent.rejectMission(String missionId) = _RejectMission;
  const factory MissionEvent.updateStatus(String missionId, String status) = _UpdateStatus;
}

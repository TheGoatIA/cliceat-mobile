part of 'mission_bloc.dart';

abstract class MissionEvent {
  const MissionEvent();

  static MissionEvent started() => const _Started();
  static MissionEvent loadActiveMissions() => const _LoadActiveMissions();
  static MissionEvent acceptMission(String missionId) => _AcceptMission(missionId);
  static MissionEvent rejectMission(String missionId) => _RejectMission(missionId);
  static MissionEvent updateStatus(String missionId, String status, {Map<String, dynamic> metadata = const {}}) 
      => _UpdateStatus(missionId, status, metadata: metadata);
}

class _Started extends MissionEvent {
  const _Started();
}

class _LoadActiveMissions extends MissionEvent {
  const _LoadActiveMissions();
}

class _AcceptMission extends MissionEvent {
  final String missionId;
  const _AcceptMission(this.missionId);
}

class _RejectMission extends MissionEvent {
  final String missionId;
  const _RejectMission(this.missionId);
}

class _UpdateStatus extends MissionEvent {
  final String missionId;
  final String status;
  final Map<String, dynamic> metadata;
  const _UpdateStatus(this.missionId, this.status, {this.metadata = const {}});
}

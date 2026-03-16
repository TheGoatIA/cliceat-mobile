import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../../data/datasources/mission_service.dart';

part 'mission_event.dart';
part 'mission_state.dart';
part 'mission_bloc.freezed.dart';

@injectable
class MissionBloc extends Bloc<MissionEvent, MissionState> {
  final MissionService _missionService;
  final Logger _logger = Logger();

  MissionBloc(this._missionService) : super(const MissionState.initial()) {
    on<_LoadActiveMissions>((event, emit) async {
      emit(const MissionState.loading());
      try {
        final res = await _missionService.getActiveMissions();
        if (res.isSuccessful && res.body != null) {
          final data = res.body?['data'] as List<dynamic>? ?? [];
          final missions = data.map((e) => e as Map<String, dynamic>).toList();
          emit(MissionState.loaded(missions));
        } else {
          emit(const MissionState.error("Impossible de récupérer les missions."));
        }
      } catch (e) {
        _logger.e("Error loading missions: $e");
        emit(MissionState.error(e.toString()));
      }
    });

    on<_AcceptMission>((event, emit) async {
      emit(const MissionState.loading());
      try {
        final res = await _missionService.acceptMission(event.missionId);
        if (res.isSuccessful) {
          emit(const MissionState.actionSuccess("Mission acceptée !"));
          add(const MissionEvent.loadActiveMissions());
        } else {
          emit(const MissionState.error("Impossible d'accepter la mission."));
        }
      } catch (e) {
        _logger.e("Error accepting mission: $e");
        emit(MissionState.error(e.toString()));
      }
    });

    on<_RejectMission>((event, emit) async {
      emit(const MissionState.loading());
      try {
        final res = await _missionService.rejectMission(event.missionId);
        if (res.isSuccessful) {
          emit(const MissionState.actionSuccess("Mission refusée."));
          add(const MissionEvent.loadActiveMissions());
        } else {
          emit(const MissionState.error("Impossible de refuser la mission."));
        }
      } catch (e) {
        _logger.e("Error rejecting mission: $e");
        emit(MissionState.error(e.toString()));
      }
    });

    on<_UpdateStatus>((event, emit) async {
      emit(const MissionState.loading());
      try {
        final res = await _missionService.updateMissionStatus(
          event.missionId, 
          {"status": event.status}
        );
        if (res.isSuccessful) {
          emit(const MissionState.actionSuccess("Statut mis à jour !"));
          add(const MissionEvent.loadActiveMissions());
        } else {
          emit(const MissionState.error("Erreur mise à jour statut."));
        }
      } catch (e) {
        _logger.e("Error updating mission status: $e");
        emit(MissionState.error(e.toString()));
      }
    });
  }
}

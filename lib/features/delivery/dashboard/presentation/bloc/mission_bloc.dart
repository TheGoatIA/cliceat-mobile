<<<<<<< HEAD
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import '../../../../../core/errors/app_error.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/driver_repository.dart';
import '../../../../../core/services/analytics_service.dart';
import 'package:cliceat_app/di/injection.dart';
=======
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../../data/datasources/mission_service.dart';
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

part 'mission_event.dart';
part 'mission_state.dart';
part 'mission_bloc.freezed.dart';

<<<<<<< HEAD
class MissionBloc extends Bloc<MissionEvent, MissionState> {
  final DriverRepository _driverRepository;
  final Logger _logger = Logger();

  MissionBloc(this._driverRepository) : super(const MissionState.initial()) {
    on<_Started>((event, emit) {
      add(const MissionEvent.loadActiveMissions());
    });

    on<_LoadActiveMissions>(_onLoadActiveMissions);
    on<_AcceptMission>(_onAcceptMission);
    on<_RejectMission>(_onRejectMission);
    on<_UpdateStatus>(_onUpdateStatus);
  }

  Future<void> _onLoadActiveMissions(
      _LoadActiveMissions event, Emitter<MissionState> emit) async {
    emit(const MissionState.loading());
    final result = await _driverRepository.getActiveMissions();
    result.fold(
      (err) {
        _logger.e('Error loading missions: ${err.message}');
        emit(MissionState.error(err.message));
      },
      (missions) {
        // Convert to Map for compatibility with existing freezed state type
        final maps = missions.map((m) => m.toJson()).toList();
        emit(MissionState.loaded(maps));
      },
    );
  }

  Future<void> _onAcceptMission(
      _AcceptMission event, Emitter<MissionState> emit) async {
    emit(const MissionState.loading());
    final result =
        await _driverRepository.acceptMission(event.missionId);
    result.fold(
      (err) {
        _logger.e('Error accepting mission: ${err.message}');
        emit(MissionState.error(err.message));
      },
      (_) {
        getIt<AnalyticsService>().logMissionAccepted(event.missionId);
        emit(const MissionState.actionSuccess('mission.accepted'));
        add(const MissionEvent.loadActiveMissions());
      },
    );
  }

  Future<void> _onRejectMission(
      _RejectMission event, Emitter<MissionState> emit) async {
    emit(const MissionState.loading());
    final result =
        await _driverRepository.rejectMission(event.missionId);
    result.fold(
      (err) {
        _logger.e('Error rejecting mission: ${err.message}');
        emit(MissionState.error(err.message));
      },
      (_) => emit(
          const MissionState.actionSuccess('mission.rejected')),
    );
    add(const MissionEvent.loadActiveMissions());
  }

  Future<void> _onUpdateStatus(
      _UpdateStatus event, Emitter<MissionState> emit) async {
    emit(const MissionState.loading());

    late final Either<AppError, void> result;
    switch (event.status) {
      case 'picked_up':
        result =
            await _driverRepository.confirmPickup(event.missionId);
        break;
      case 'delivered':
        result = await _driverRepository.confirmDelivery(
          event.missionId,
          metadata: event.metadata,
        );
        getIt<AnalyticsService>()
            .logDeliveryCompleted(event.missionId);
        break;
      default:
        emit(MissionState.error('mission.error_unknown_status'));
        return;
    }

    result.fold(
      (err) {
        _logger.e('Error updating mission status: ${err.message}');
        emit(const MissionState.error('mission.error_update_status'));
      },
      (_) {
        emit(const MissionState.actionSuccess(
            'mission.status_updated'));
        add(const MissionEvent.loadActiveMissions());
      },
    );
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
  }
}

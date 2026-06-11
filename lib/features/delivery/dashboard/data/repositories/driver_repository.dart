import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/earnings_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/datasources/mission_service.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/datasources/driver_service.dart';

/// Abstracts delivery driver operations: missions, earnings, status, location.
@lazySingleton
class DriverRepository {
  final MissionService _missionService;
  final DriverService _driverService;

  DriverRepository(this._missionService, this._driverService);

  // ─── Missions ─────────────────────────────────────────────────────────────

  Future<Either<AppError, List<MissionModel>>> getActiveMissions() async {
    try {
      final res = await _missionService.getMyOrders();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'];
        List<dynamic> raw = [];
        if (data is List) {
          raw = data;
        } else if (data is Map<String, dynamic>) {
          raw =
              data['items'] as List<dynamic>? ??
              data['orders'] as List<dynamic>? ??
              data['missions'] as List<dynamic>? ??
              [];
        }

        final missions = raw
            .whereType<Map<String, dynamic>>()
            .map(MissionModel.fromJson)
            .toList();
        return Right(missions);
      }
      return Left(
        AppError.fromResponse(
          res.body,
          'mission.error_load',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[driver_repository.dart] getActiveMissions error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> acceptMission(String id) async {
    try {
      final res = await _missionService.acceptMission(id);
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'mission.error_accept',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[driver_repository.dart] acceptMission error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> rejectMission(String id) async {
    try {
      final res = await _missionService.rejectMission(id);
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'mission.error_reject',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[driver_repository.dart] rejectMission error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> confirmPickup(String id) async {
    try {
      final res = await _missionService.confirmPickup(id);
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'mission.error_update_status',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[driver_repository.dart] confirmPickup error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> confirmDelivery(
    String id, {
    Map<String, dynamic> metadata = const {},
  }) async {
    try {
      final res = await _missionService.confirmDelivery(id, metadata);
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(
          res.body,
          'mission.error_update_status',
          statusCode: res.statusCode,
        ),
      );
    } catch (e, s) {
      debugPrint('[driver_repository.dart] confirmDelivery error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> reportMission(
    String id,
    Map<String, dynamic> report,
  ) async {
    try {
      final res = await _missionService.reportMission(id, report);
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (e, s) {
      debugPrint('[driver_repository.dart] reportMission error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── Profile ──────────────────────────────────────────────────────────────

  Future<Either<AppError, Map<String, dynamic>>> getProfile() async {
    try {
      // We can use the /users/me endpoint which we just fixed on the backend
      // for both users and drivers.
      final res = await _driverService.getProfile();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        final profile =
            data['user'] as Map<String, dynamic>? ??
            data['driver'] as Map<String, dynamic>? ??
            data;
        return Right(profile);
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (e, s) {
      debugPrint('[driver_repository.dart] getProfile error: $e\n$s');
      return Left(AppError.network());
    }
  }

  // ─── Driver status ────────────────────────────────────────────────────────

  Future<Either<AppError, void>> updateOnlineStatus(bool isOnline) async {
    try {
      final res = await _driverService.updateStatus({'isOnline': isOnline});
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (e, s) {
      debugPrint('[driver_repository.dart] updateOnlineStatus error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<void> updateLocation(double lat, double lng) async {
    try {
      await _driverService.updateLocation({'lat': lat, 'lng': lng});
    } catch (e) {
      // Location update is best-effort — non-critical, server will use last known position
      debugPrint('[driver_repository.dart] updateLocation error: $e');
    }
  }

  // ─── Earnings ─────────────────────────────────────────────────────────────

  Future<Either<AppError, EarningsModel>> getEarnings() async {
    try {
      final res = await _driverService.getMyEarnings();
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        final data = body['data'] as Map<String, dynamic>? ?? body;
        return Right(EarningsModel.fromJson(data));
      }
      return Left(AppError.fromResponse(res.body, 'common.error'));
    } catch (e, s) {
      debugPrint('[driver_repository.dart] getEarnings error: $e\n$s');
      return Left(AppError.network());
    }
  }
}

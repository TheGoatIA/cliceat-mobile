import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/core/network/services/referral_service.dart';
import '../models/referral_model.dart';

@injectable
class ReferralRepository {
  final ReferralService _service;
  ReferralRepository(this._service);

  Future<Either<AppError, String>> getMyCode() async {
    try {
      final res = await _service.getMyCode();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>;
        return Right(data['referralCode']?.toString() ?? '');
      }
      return Left(AppError.fromResponse(res.body, 'referral.error_load'));
    } catch (e, s) {
      debugPrint('[referral_repository.dart] getMyCode error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> applyCode(String code) async {
    try {
      final res = await _service.applyCode({'code': code});
      if (res.isSuccessful) {
        return const Right(null);
      }
      return Left(AppError.fromResponse(res.body, 'referral.error_apply'));
    } catch (e, s) {
      debugPrint('[referral_repository.dart] applyCode error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, ReferralStatsModel>> getStats() async {
    try {
      final res = await _service.getStats();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>? ?? res.body!;
        return Right(ReferralStatsModel.fromJson(data));
      }
      return Left(AppError.fromResponse(res.body, 'referral.error_load'));
    } catch (e, s) {
      debugPrint('[referral_repository.dart] getStats error: $e\n$s');
      return Left(AppError.network());
    }
  }
}

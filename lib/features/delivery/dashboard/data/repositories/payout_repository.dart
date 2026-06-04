import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/datasources/payout_service.dart';

@lazySingleton
class PayoutRepository {
  final PayoutService _payoutService;

  PayoutRepository(this._payoutService);

  Future<Either<AppError, List<Map<String, dynamic>>>> getPayouts() async {
    try {
      final res = await _payoutService.getPayouts();
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as List<dynamic>? ?? [];
        return Right(data.cast<Map<String, dynamic>>());
      }
      return Left(AppError.fromResponse(res.body, 'payout.load_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> requestPayout(double amount) async {
    try {
      final res = await _payoutService.requestPayout({'amount': amount});
      if (res.isSuccessful) return const Right(null);
      return Left(AppError.fromResponse(res.body, 'payout.request_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, Map<String, dynamic>>> getPayoutAccount() async {
    try {
      final res = await _payoutService.getPayoutAccount();
      if (res.isSuccessful && res.body != null) {
        return Right(res.body!['data'] as Map<String, dynamic>);
      }
      return Left(AppError.fromResponse(res.body, 'payout.account_error'));
    } catch (_) {
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, void>> updatePayoutAccount({
    required String method, // 'momo' or 'om'
    required String phoneNumber,
    required String accountName,
  }) async {
    try {
      final res = await _payoutService.updatePayoutAccount({
        'channel': method == 'om' ? 'cm.orange' : 'cm.mobile',
        'accountNumber': phoneNumber,
        'name': accountName,
      });
      if (res.isSuccessful) return const Right(null);
      return Left(
        AppError.fromResponse(res.body, 'payout.update_account_error'),
      );
    } catch (_) {
      return Left(AppError.network());
    }
  }
}

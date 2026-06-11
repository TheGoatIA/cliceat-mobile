import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cliceat_app/features/client/wallet/data/datasources/wallet_service.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/payment_service.dart';

@lazySingleton
class WalletRepository {
  final WalletService _walletService;
  final PaymentService _paymentService;

  WalletRepository(this._walletService, this._paymentService);

  Future<Either<AppError, Map<String, String>>> recharge(
    double amount,
    String method,
  ) async {
    try {
      final res = await _walletService.recharge({
        'amount': amount,
        'method': method,
      });
      if (res.isSuccessful && res.body != null) {
        final dataObj = res.body!['data'] as Map<String, dynamic>?;
        final paymentUrl = dataObj?['paymentUrl'] as String?;
        final reference = dataObj?['reference'] as String?;
        if (paymentUrl != null && reference != null) {
          return Right({'paymentUrl': paymentUrl, 'reference': reference});
        }
      }
      return Left(AppError.fromResponse(res.body, 'wallet.recharge_error'));
    } catch (e, s) {
      debugPrint('[wallet_repository.dart] recharge error: $e\n$s');
      return Left(AppError.network());
    }
  }

  Future<Either<AppError, List<Map<String, dynamic>>>> getHistory() async {
    try {
      final res = await _paymentService.getMyPayments();
      if (res.isSuccessful && res.body != null) {
        final dataObj = res.body!['data'] as Map<String, dynamic>?;
        final items = dataObj?['items'] as List<dynamic>? ?? [];
        return Right(items.cast<Map<String, dynamic>>());
      }
      return Left(AppError.fromResponse(res.body, 'wallet.history_error'));
    } catch (e, s) {
      debugPrint('[wallet_repository.dart] getHistory error: $e\n$s');
      return Left(AppError.network());
    }
  }
}

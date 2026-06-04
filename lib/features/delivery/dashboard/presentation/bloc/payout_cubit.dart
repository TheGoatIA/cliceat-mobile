import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/payout_repository.dart';

part 'payout_state.dart';
part 'payout_cubit.freezed.dart';

@injectable
class PayoutCubit extends Cubit<PayoutState> {
  final PayoutRepository _repository;

  PayoutCubit(this._repository) : super(const PayoutState.initial());

  Future<void> loadPayoutData() async {
    emit(const PayoutState.loading());
    final results = await Future.wait([
      _repository.getPayouts(),
      _repository.getPayoutAccount(),
    ]);

    final payoutsRes = results[0] as Either;
    final accountRes = results[1] as Either;

    payoutsRes.fold(
      (err) => emit(PayoutState.error(err.message)),
      (payouts) {
        accountRes.fold(
          (err) => emit(PayoutState.loaded(payouts: payouts.cast<Map<String, dynamic>>(), account: null)),
          (account) => emit(PayoutState.loaded(payouts: payouts.cast<Map<String, dynamic>>(), account: account as Map<String, dynamic>)),
        );
      },
    );
  }

  Future<void> requestPayout(double amount) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    emit(const PayoutState.loading());
    final result = await _repository.requestPayout(amount);
    result.fold(
      (err) => emit(PayoutState.error(err.message)),
      (_) => loadPayoutData(),
    );
  }

  Future<void> updateAccount({
    required String method,
    required String phoneNumber,
    required String accountName,
  }) async {
    emit(const PayoutState.loading());
    final result = await _repository.updatePayoutAccount(
      method: method,
      phoneNumber: phoneNumber,
      accountName: accountName,
    );
    result.fold(
      (err) => emit(PayoutState.error(err.message)),
      (_) => loadPayoutData(),
    );
  }
}

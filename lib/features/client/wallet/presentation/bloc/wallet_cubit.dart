import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/features/client/wallet/data/repositories/wallet_repository.dart';

part 'wallet_state.dart';
part 'wallet_cubit.freezed.dart';

@injectable
class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit(this._repository) : super(const WalletState.initial());

  Future<void> loadHistory() async {
    emit(const WalletState.loading());
    final result = await _repository.getHistory();
    result.fold(
      (err) => emit(WalletState.error(err.message)),
      (history) => emit(WalletState.loaded(history)),
    );
  }

  Future<void> recharge(double amount, String method) async {
    emit(const WalletState.loading());
    final result = await _repository.recharge(amount, method);
    result.fold(
      (err) => emit(WalletState.error(err.message)),
      (paymentUrl) => emit(WalletState.rechargeInitiated(paymentUrl)),
    );
  }
}

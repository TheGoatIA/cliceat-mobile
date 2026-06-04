part of 'wallet_cubit.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = _Initial;
  const factory WalletState.loading() = _Loading;
  const factory WalletState.loaded(List<Map<String, dynamic>> history) =
      _Loaded;
  const factory WalletState.rechargeInitiated(String paymentUrl) =
      _RechargeInitiated;
  const factory WalletState.error(String message) = _Error;
}

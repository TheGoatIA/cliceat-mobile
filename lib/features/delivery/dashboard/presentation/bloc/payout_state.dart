part of 'payout_cubit.dart';

@freezed
class PayoutState with _$PayoutState {
  const factory PayoutState.initial() = _Initial;
  const factory PayoutState.loading() = _Loading;
  const factory PayoutState.loaded({
    required List<Map<String, dynamic>> payouts,
    Map<String, dynamic>? account,
  }) = _Loaded;
  const factory PayoutState.error(String message) = _Error;
}

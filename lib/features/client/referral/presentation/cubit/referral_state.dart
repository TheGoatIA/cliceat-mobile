import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/referral_model.dart';

part 'referral_state.freezed.dart';

@freezed
class ReferralState with _$ReferralState {
  const factory ReferralState.initial() = _Initial;
  const factory ReferralState.loading() = _Loading;
  const factory ReferralState.loaded({required ReferralStatsModel stats}) =
      _Loaded;
  const factory ReferralState.codeApplied() = _CodeApplied;
  const factory ReferralState.error(String message) = _Error;
}

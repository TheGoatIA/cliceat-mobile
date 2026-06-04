part of 'promotion_cubit.dart';

@freezed
class PromotionState with _$PromotionState {
  const factory PromotionState.initial() = _Initial;
  const factory PromotionState.loading() = _Loading;
  const factory PromotionState.loaded(List<Map<String, dynamic>> promotions) =
      _Loaded;
  const factory PromotionState.error(String message) = _Error;
}

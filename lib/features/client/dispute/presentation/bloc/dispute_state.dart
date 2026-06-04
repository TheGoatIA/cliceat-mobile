part of 'dispute_cubit.dart';

@freezed
class DisputeState with _$DisputeState {
  const factory DisputeState.initial() = _Initial;
  const factory DisputeState.loading() = _Loading;
  const factory DisputeState.loaded(List<Map<String, dynamic>> disputes) =
      _Loaded;
  const factory DisputeState.success() = _Success;
  const factory DisputeState.error(String message) = _Error;
}

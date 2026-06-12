part of 'shorts_cubit.dart';

@freezed
class ShortsState with _$ShortsState {
  const factory ShortsState.idle() = _Idle;
  const factory ShortsState.loading() = _Loading;
  const factory ShortsState.loaded({
    required List<VideoReviewModel> videos,
    required bool hasMore,
  }) = _Loaded;
  const factory ShortsState.error(String message) = _Error;
}

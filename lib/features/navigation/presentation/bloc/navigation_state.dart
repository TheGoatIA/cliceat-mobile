part of 'navigation_cubit.dart';

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState.idle() = _Idle;
  const factory NavigationState.loading() = _Loading;
  const factory NavigationState.navigating({
    required OsrmRoute route,
    required int currentStepIndex,
    required double currentLat,
    required double currentLng,
    @Default(false) bool isRerouting,
  }) = _Navigating;
  const factory NavigationState.arrived({
    required OsrmRoute route,
  }) = _Arrived;
  const factory NavigationState.error(String message) = _Error;
}

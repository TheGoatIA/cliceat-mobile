part of 'navigation_cubit.dart';

@freezed
abstract class NavigationState with _$NavigationState {
  const factory NavigationState.idle() = NavigationIdle;
  const factory NavigationState.loading() = NavigationLoading;
  const factory NavigationState.navigating({
    required OsrmRoute route,
    required int currentStepIndex,
    required double currentLat,
    required double currentLng,
    @Default(false) bool isRerouting,
  }) = NavigationNavigating;
  const factory NavigationState.arrived({required OsrmRoute route}) =
      NavigationArrived;
  const factory NavigationState.error(String message) = NavigationError;
}

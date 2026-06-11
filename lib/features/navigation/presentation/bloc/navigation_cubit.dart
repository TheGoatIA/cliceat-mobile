import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/models/osrm_route_model.dart';
import '../../data/repositories/navigation_repository.dart';

part 'navigation_state.dart';
part 'navigation_cubit.freezed.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final NavigationRepository _repository;
  final FlutterTts _tts = FlutterTts();

  StreamSubscription<Position>? _locationSub;
  OsrmRoute? _currentRoute;
  int _currentStepIndex = 0;
  double? _destLat;
  double? _destLng;
  String? _orderId;

  // Deviation threshold in metres before triggering reroute
  static const double _deviationThreshold = 80.0;
  static const double _stepCompletedThreshold = 25.0;
  static const double _arrivalThreshold = 40.0;

  NavigationCubit(this._repository) : super(const NavigationState.idle()) {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('fr-FR');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
  }

  Future<void> startNavigation({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String? orderId,
  }) async {
    emit(const NavigationState.loading());
    _destLat = destLat;
    _destLng = destLng;
    _orderId = orderId;
    _currentStepIndex = 0;

    try {
      final result = await _repository.computeRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
        orderId: orderId,
      );
      _currentRoute = result.route;
      emit(NavigationState.navigating(
        route: result.route,
        currentStepIndex: 0,
        currentLat: originLat,
        currentLng: originLng,
      ));
      _speakStep(0);
      _startLocationTracking();
    } catch (e) {
      emit(NavigationState.error(e.toString()));
    }
  }

  void _startLocationTracking() {
    _locationSub?.cancel();
    _locationSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen(_onLocationUpdate);
  }

  void _onLocationUpdate(Position pos) {
    final route = _currentRoute;
    if (route == null) return;
    final steps = route.allSteps;
    if (steps.isEmpty) return;

    final lat = pos.latitude;
    final lng = pos.longitude;

    // Check arrival
    final distToDest = Geolocator.distanceBetween(lat, lng, _destLat!, _destLng!);
    if (distToDest <= _arrivalThreshold) {
      _locationSub?.cancel();
      _tts.speak('Vous êtes arrivé à destination');
      emit(NavigationState.arrived(route: route));
      return;
    }

    // Advance step if close enough to next step
    if (_currentStepIndex < steps.length - 1) {
      final nextStep = steps[_currentStepIndex + 1];
      // Use step geometry if available — otherwise estimate via distance
      // Simple approach: if user is within threshold of current step end, advance
      final stepDist = Geolocator.distanceBetween(
        lat, lng,
        // We don't have exact waypoint coords per step from OSRM in this model,
        // so we estimate by cumulative distance heuristic
        lat, lng, // placeholder — step advancement uses distance remaining
      );
      // Advance based on distance threshold from start
      final distToRemaining = distToDest;
      final stepDistRemaining = steps
          .skip(_currentStepIndex + 1)
          .fold(0.0, (sum, s) => sum + s.distance);

      if (distToRemaining < stepDistRemaining + _stepCompletedThreshold) {
        _currentStepIndex++;
        _speakStep(_currentStepIndex);
      }
    }

    emit(NavigationState.navigating(
      route: route,
      currentStepIndex: _currentStepIndex,
      currentLat: lat,
      currentLng: lng,
    ));
  }

  Future<void> requestReroute() async {
    final route = _currentRoute;
    if (route == null || _destLat == null || _destLng == null) return;

    try {
      final pos = await Geolocator.getCurrentPosition();
      final result = await _repository.reroute(
        currentLat: pos.latitude,
        currentLng: pos.longitude,
        destLat: _destLat!,
        destLng: _destLng!,
        orderId: _orderId ?? '',
      );
      _currentRoute = result.route;
      _currentStepIndex = 0;
      emit(NavigationState.navigating(
        route: result.route,
        currentStepIndex: 0,
        currentLat: pos.latitude,
        currentLng: pos.longitude,
        isRerouting: true,
      ));
      _tts.speak('Recalcul de l\'itinéraire');
      _speakStep(0);
    } catch (e) {
      debugPrint('Reroute failed: $e');
    }
  }

  void _speakStep(int index) {
    final steps = _currentRoute?.allSteps;
    if (steps == null || index >= steps.length) return;
    final step = steps[index];
    _tts.speak(step.displayInstruction);
  }

  void stopNavigation() {
    _locationSub?.cancel();
    _tts.stop();
    _currentRoute = null;
    _currentStepIndex = 0;
    emit(const NavigationState.idle());
  }

  @override
  Future<void> close() {
    _locationSub?.cancel();
    _tts.stop();
    return super.close();
  }
}

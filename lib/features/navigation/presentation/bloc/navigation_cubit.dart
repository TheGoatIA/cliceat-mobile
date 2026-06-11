import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/websocket_service.dart';
import '../../data/datasources/navigation_cache.dart';
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
    // Cancel any existing tracking before restarting
    _locationSub?.cancel();
    _locationSub = null;
    emit(const NavigationState.loading());
    _destLat = destLat;
    _destLng = destLng;
    _orderId = orderId;
    _currentStepIndex = 0;
    _distanceCovered = 0.0;
    _lastLat = null;
    _lastLng = null;

    // Try loading from cache first for offline/fast start
    final cached = await NavigationCache.loadRoute(orderId ?? '');
    if (cached != null) {
      _currentRoute = cached;
      emit(NavigationState.navigating(
        route: cached,
        currentStepIndex: 0,
        currentLat: originLat,
        currentLng: originLng,
      ));
      _speakStep(0);
      _startLocationTracking();
      // Fetch fresh route in background and update
      _repository.computeRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
        orderId: orderId,
      ).then((result) {
        _currentRoute = result.route;
        NavigationCache.saveRoute(result.route, orderId ?? '');
        if (state is NavigationNavigating) {
          final s = state as NavigationNavigating;
          emit(NavigationState.navigating(
            route: result.route,
            currentStepIndex: s.currentStepIndex,
            currentLat: s.currentLat,
            currentLng: s.currentLng,
          ));
        }
      }).catchError((e) {
        debugPrint('Background route refresh failed: $e');
      });
      return;
    }

    try {
      final result = await _repository.computeRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
        orderId: orderId,
      );
      _currentRoute = result.route;
      await NavigationCache.saveRoute(result.route, orderId ?? '');
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

  // Cumulative distance covered along the route (metres)
  double _distanceCovered = 0.0;
  double? _lastLat;
  double? _lastLng;

  void _onLocationUpdate(Position pos) {
    final route = _currentRoute;
    if (route == null) return;
    final steps = route.allSteps;
    if (steps.isEmpty) return;

    final lat = pos.latitude;
    final lng = pos.longitude;

    // Accumulate distance from last known position
    if (_lastLat != null && _lastLng != null) {
      _distanceCovered += Geolocator.distanceBetween(_lastLat!, _lastLng!, lat, lng);
    }
    _lastLat = lat;
    _lastLng = lng;

    // Check arrival at destination
    final distToDest = Geolocator.distanceBetween(lat, lng, _destLat!, _destLng!);
    if (distToDest <= _arrivalThreshold) {
      _locationSub?.cancel();
      _tts.speak('Vous êtes arrivé à destination');
      emit(NavigationState.arrived(route: route));
      return;
    }

    // Advance steps based on cumulative distance along route
    // Each step occupies a known distance — advance when covered >= sum of completed steps
    double stepCutoff = 0.0;
    for (int i = 0; i <= _currentStepIndex && i < steps.length; i++) {
      stepCutoff += steps[i].distance;
    }
    if (_currentStepIndex < steps.length - 1 &&
        _distanceCovered >= stepCutoff - _stepCompletedThreshold) {
      _currentStepIndex++;
      _speakStep(_currentStepIndex);
      // Emit step update to server
      if (_orderId != null && _orderId!.isNotEmpty) {
        getIt<WebSocketService>().emitNavUpdate(
          orderId: _orderId!,
          stepIndex: _currentStepIndex,
          lat: lat,
          lng: lng,
        );
      }
    }

    // Auto-reroute if significantly off track (deviation from expected cumulative distance)
    final expectedDistCovered = stepCutoff;
    final deviation = (distToDest - (route.distance - expectedDistCovered)).abs();
    if (deviation > _deviationThreshold && _currentStepIndex > 0) {
      // Trigger background reroute — don't await, let it update state when done
      requestReroute();
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
      _distanceCovered = 0.0;
      _lastLat = null;
      _lastLng = null;
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

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/services/tracking_service.dart';
import '../../../../../core/network/socket_service.dart';

// Events
abstract class TrackingEvent {}

class TrackingStarted extends TrackingEvent {
  final String orderId;
  TrackingStarted(this.orderId);
}

class TrackingDriverLocationReceived extends TrackingEvent {
  final double lat;
  final double lng;
  TrackingDriverLocationReceived(this.lat, this.lng);
}

class TrackingStatusReceived extends TrackingEvent {
  final String status;
  TrackingStatusReceived(this.status);
}

class TrackingEtaReceived extends TrackingEvent {
  final int etaMinutes;
  TrackingEtaReceived(this.etaMinutes);
}

class TrackingStopped extends TrackingEvent {}

// State
class TrackingState {
  final String orderId;
  final String status;
  final double? driverLat;
  final double? driverLng;
  final double? destLat;
  final double? destLng;
  final int? etaMinutes;
  final bool isLoading;
  final String? error;

  const TrackingState({
    this.orderId = '',
    this.status = 'pending',
    this.driverLat,
    this.driverLng,
    this.destLat,
    this.destLng,
    this.etaMinutes,
    this.isLoading = false,
    this.error,
  });

  TrackingState copyWith({
    String? orderId,
    String? status,
    double? driverLat,
    double? driverLng,
    double? destLat,
    double? destLng,
    int? etaMinutes,
    bool? isLoading,
    String? error,
  }) =>
      TrackingState(
        orderId: orderId ?? this.orderId,
        status: status ?? this.status,
        driverLat: driverLat ?? this.driverLat,
        driverLng: driverLng ?? this.driverLng,
        destLat: destLat ?? this.destLat,
        destLng: destLng ?? this.destLng,
        etaMinutes: etaMinutes ?? this.etaMinutes,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingService _trackingService;
  final SocketService _socketService;

  TrackingBloc(this._trackingService, this._socketService)
      : super(const TrackingState()) {
    on<TrackingStarted>(_onStarted);
    on<TrackingDriverLocationReceived>(_onLocation);
    on<TrackingStatusReceived>(_onStatus);
    on<TrackingEtaReceived>(_onEta);
    on<TrackingStopped>(_onStopped);
  }

  Future<void> _onStarted(
      TrackingStarted event, Emitter<TrackingState> emit) async {
    emit(state.copyWith(isLoading: true, orderId: event.orderId));
    try {
      final resp = await _trackingService.getTracking(event.orderId);
      if (resp.isSuccessful) {
        final data =
            (resp.body as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
        final driver = data?['driver'] as Map<String, dynamic>?;
        final location = driver?['location'] as Map<String, dynamic>?;
        final coords = location?['coordinates'] as List?;
        final dest = data?['deliveryAddress'] as Map<String, dynamic>?;
        final destCoords =
            (dest?['location'] as Map?)?['coordinates'] as List?;

        emit(state.copyWith(
          isLoading: false,
          status: data?['status'] as String? ?? 'pending',
          driverLat: coords != null ? (coords[1] as num).toDouble() : null,
          driverLng: coords != null ? (coords[0] as num).toDouble() : null,
          destLat:
              destCoords != null ? (destCoords[1] as num).toDouble() : null,
          destLng:
              destCoords != null ? (destCoords[0] as num).toDouble() : null,
        ));
      } else {
        emit(state.copyWith(
            isLoading: false, error: 'Impossible de charger le suivi'));
      }

      // Subscribe to real-time socket events
      _socketService.subscribeToOrder(event.orderId);
      _socketService.onDriverLocation((data) {
        add(TrackingDriverLocationReceived(
          (data['lat'] as num).toDouble(),
          (data['lng'] as num).toDouble(),
        ));
      });
      _socketService.onTrackingUpdate((data) {
        final status = data['status'] as String?;
        if (status != null) add(TrackingStatusReceived(status));
      });

      // Fetch ETA
      final etaResp = await _trackingService.getEta(event.orderId);
      if (etaResp.isSuccessful) {
        final etaData =
            (etaResp.body as Map<String, dynamic>)['data'] as Map?;
        final eta = etaData?['eta'] as int?;
        if (eta != null) add(TrackingEtaReceived(eta));
      }
    } catch (_) {
      emit(state.copyWith(
          isLoading: false, error: 'Erreur réseau. Vérifiez votre connexion.'));
    }
  }

  void _onLocation(
      TrackingDriverLocationReceived event, Emitter<TrackingState> emit) {
    emit(state.copyWith(driverLat: event.lat, driverLng: event.lng));
  }

  void _onStatus(TrackingStatusReceived event, Emitter<TrackingState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onEta(TrackingEtaReceived event, Emitter<TrackingState> emit) {
    emit(state.copyWith(etaMinutes: event.etaMinutes));
  }

  void _onStopped(TrackingStopped event, Emitter<TrackingState> emit) {
    _socketService.offTrackingEvents();
    if (state.orderId.isNotEmpty) {
      _socketService.unsubscribeFromOrder(state.orderId);
    }
  }

  @override
  Future<void> close() {
    _socketService.offTrackingEvents();
    return super.close();
  }
}

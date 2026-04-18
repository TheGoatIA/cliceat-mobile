import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../bloc/tracking_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/tracking_service.dart';
import '../../../../../core/network/socket_service.dart';

class TrackingPage extends StatelessWidget {
  final String orderId;

  const TrackingPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackingBloc(
        getIt<TrackingService>(),
        getIt<SocketService>(),
      )..add(TrackingStarted(orderId)),
      child: _TrackingView(orderId: orderId),
    );
  }
}

class _TrackingView extends StatefulWidget {
  final String orderId;
  const _TrackingView({required this.orderId});

  @override
  State<_TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<_TrackingView> {
  MapboxMap? _mapController;
  PointAnnotationManager? _annotationManager;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrackingBloc, TrackingState>(
      listenWhen: (prev, curr) =>
          prev.driverLat != curr.driverLat ||
          prev.driverLng != curr.driverLng,
      listener: (context, state) {
        if (state.driverLat != null && state.driverLng != null) {
          _updateDriverMarker(state.driverLat!, state.driverLng!);
        }
      },
      child: Scaffold(
        body: BlocBuilder<TrackingBloc, TrackingState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Map
                MapWidget(
                  onMapCreated: (controller) async {
                    _mapController = controller;
                    _annotationManager = await controller
                        .annotations
                        .createPointAnnotationManager();
                    if (state.driverLat != null) {
                      _updateDriverMarker(
                          state.driverLat!, state.driverLng!);
                    }
                    // Camera
                    final lat = state.driverLat ?? 3.848;
                    final lng = state.driverLng ?? 11.502;
                    await controller.flyTo(
                      CameraOptions(
                        center: Point(
                            coordinates: Position(lng, lat)),
                        zoom: 14.0,
                      ),
                      null,
                    );
                  },
                ),

                // Top bar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black12)
                              ],
                            ),
                            child: Text(
                              state.etaMinutes != null
                                  ? 'Arrivée estimée dans ${state.etaMinutes} min'
                                  : 'Calcul du temps...',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom sheet
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BottomTrackingSheet(state: state),
                ),

                if (state.isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                        child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateDriverMarker(double lat, double lng) async {
    if (_annotationManager == null) return;
    await _annotationManager!.deleteAll();
    await _annotationManager!.create(
      PointAnnotationOptions(
        geometry:
            Point(coordinates: Position(lng, lat)),
        iconSize: 1.5,
      ),
    );
    await _mapController?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: 15.0,
      ),
      null,
    );
  }
}

class _BottomTrackingSheet extends StatelessWidget {
  final TrackingState state;
  const _BottomTrackingSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = [
      ('Commande confirmée', 'confirmed'),
      ('En préparation', 'preparing'),
      ('Prise en charge', 'picked_up'),
      ('En route', 'on_the_way'),
      ('Livré', 'delivered'),
    ];

    int currentStep = 0;
    for (var i = 0; i < steps.length; i++) {
      if (state.status == steps[i].$2) currentStep = i;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black26)],
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Suivi de commande',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Stepper(
            currentStep: currentStep,
            physics: const NeverScrollableScrollPhysics(),
            controlsBuilder: (_, __) => const SizedBox.shrink(),
            steps: steps
                .map((s) => Step(
                      title: Text(s.$1),
                      content: const SizedBox.shrink(),
                      isActive: steps.indexOf(s) <= currentStep,
                      state: steps.indexOf(s) < currentStep
                          ? StepState.complete
                          : steps.indexOf(s) == currentStep
                              ? StepState.indexed
                              : StepState.disabled,
                    ))
                .toList(),
          ),
          if (state.status == 'delivered')
            FilledButton(
              onPressed: () => context.go('/client'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              child: const Text('Terminé — Retour à l\'accueil'),
            ),
        ],
      ),
    );
  }
}

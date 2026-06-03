import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cliceat_app/core/config/app_constants.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/core/config/flavor_config.dart';

class MapPickerPage extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerPage({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  MapboxMap? _mapboxMap;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onMapCreated(MapboxMap map) async {
    _mapboxMap = map;
    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    map.compass.updateSettings(CompassSettings(enabled: false));
    map.attribution.updateSettings(AttributionSettings(enabled: false));
    map.logo.updateSettings(LogoSettings(enabled: false));
  }

  Future<void> _centerOnUser() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(pos.longitude, pos.latitude)),
          zoom: 15,
        ),
        MapAnimationOptions(duration: 800),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('client.location_error'.tr())));
      }
    }
  }

  Future<void> _confirmLocation() async {
    if (_mapboxMap == null) return;

    setState(() => _isLoading = true);

    try {
      final cameraState = await _mapboxMap!.getCameraState();
      final center = cameraState.center;

      final Position coord = center.coordinates;
      final double lng = coord.lng.toDouble();
      final double lat = coord.lat.toDouble();

      String addressName = '$lat, $lng';

      // Reverse Geocoding with Backend API (Nominatim/Mapbox wrapper)
      final baseUrl = FlavorConfig.apiBaseUrl;
      final url = Uri.parse('$baseUrl/geocoding/reverse?lat=$lat&lng=$lng');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          addressName =
              data['data']['address'] ??
              data['data']['formatted_address'] ??
              addressName;
        }
      }

      if (mounted) {
        context.pop({'lat': lat, 'lng': lng, 'address': addressName});
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error'.tr())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initLat = widget.initialLat ?? AppConstants.defaultLat;
    final initLng = widget.initialLng ?? AppConstants.defaultLng;

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(initLng, initLat)),
              zoom: widget.initialLat != null ? 16.0 : AppConstants.defaultZoom,
            ),
          ),

          // Marker Overlay
          const Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 40,
              ), // Center the bottom tip of the pin
              child: Icon(
                Icons.location_on,
                size: 40,
                color: AppTheme.primaryRed,
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.surface,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // Locate Me Button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'locateMePicker',
              onPressed: _centerOnUser,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: AppTheme.primaryRed,
              child: const Icon(Icons.my_location_rounded),
            ),
          ),

          // Confirm Button
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Confirmer la position',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

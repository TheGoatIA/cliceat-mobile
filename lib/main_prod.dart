import 'package:flutter/material.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

/// Point d'entrée du flavor PRODUCTION.
///
/// Build : flutter build apk --flavor prod -t lib/main_prod.dart
void main() {
  FlavorConfig.initialize(
    flavor: Flavor.prod,
    apiBaseUrl: 'https://api.cliceat.cm/api/v1',
    wsUrl: 'wss://api.cliceat.cm',
    mapboxToken: const String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    ),
  );
  mainCommon();
}

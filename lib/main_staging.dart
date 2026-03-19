import 'core/config/flavor_config.dart';
import 'main_common.dart';

/// Point d'entrée du flavor STAGING.
///
/// Build : flutter run --flavor staging -t lib/main_staging.dart
void main() {
  FlavorConfig.initialize(
    flavor: Flavor.staging,
    apiBaseUrl: 'https://staging-api.cliceat.cm/api/v1',
    wsUrl: 'wss://staging-api.cliceat.cm',
    mapboxToken: const String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    ),
  );
  mainCommon();
}

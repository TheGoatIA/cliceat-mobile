import 'main_dev.dart' as dev;

/// Default entry point that redirects to the DEV flavor.
/// This prevents build errors when no flavor or target is specified.
void main() {
  dev.main();
}

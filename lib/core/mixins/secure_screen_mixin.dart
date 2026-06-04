import 'package:flutter/widgets.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:logger/logger.dart';

/// Mixin à appliquer sur les [State] des pages affichant des données
/// sensibles (paiement, profil, mot de passe).
///
/// Active la protection sur Android et iOS pour :
/// - Bloquer les captures d'écran
/// - Masquer le contenu dans le sélecteur d'application (App Switcher)
///
/// Usage :
/// ```dart
/// class _PaymentPageState extends State<PaymentPage>
///     with SecureScreenMixin {
///   // ...
/// }
/// ```
mixin SecureScreenMixin<T extends StatefulWidget> on State<T> {
  static final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _enableSecureMode();
  }

  @override
  void dispose() {
    _disableSecureMode();
    super.dispose();
  }

  Future<void> _enableSecureMode() async {
    try {
      await ScreenProtector.protectDataLeakageOn();
      await ScreenProtector.preventScreenshotOn();
      _logger.d('[SecureScreen] Protection activée.');
    } catch (e) {
      _logger.w('[SecureScreen] Impossible d\'activer la protection: $e');
    }
  }

  Future<void> _disableSecureMode() async {
    try {
      await ScreenProtector.protectDataLeakageOff();
      await ScreenProtector.preventScreenshotOff();
      _logger.d('[SecureScreen] Protection désactivée.');
    } catch (e) {
      _logger.w('[SecureScreen] Impossible de désactiver la protection: $e');
    }
  }
}

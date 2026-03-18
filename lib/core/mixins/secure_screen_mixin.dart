import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:logger/logger.dart';

/// Mixin à appliquer sur les [State] des pages affichant des données
/// sensibles (paiement, profil, mot de passe).
///
/// Active [FLAG_SECURE] sur Android pour :
/// - Bloquer les captures d'écran
/// - Masquer le contenu dans le sélecteur d'application (App Switcher)
///
/// Sur iOS, le système floute automatiquement le contenu dans le
/// sélecteur d'app. `FLAG_SECURE` n'existe pas sur iOS.
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
    if (!Platform.isAndroid) return;
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      _logger.d('[SecureScreen] FLAG_SECURE activé.');
    } catch (e) {
      _logger.w('[SecureScreen] Impossible d\'activer FLAG_SECURE: $e');
    }
  }

  Future<void> _disableSecureMode() async {
    if (!Platform.isAndroid) return;
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      _logger.d('[SecureScreen] FLAG_SECURE désactivé.');
    } catch (e) {
      _logger.w('[SecureScreen] Impossible de désactiver FLAG_SECURE: $e');
    }
  }
}

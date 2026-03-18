import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Affiche une bannière en bas de l'écran quand la connectivité est perdue.
///
/// À utiliser comme wrapper au-dessus du widget racine de l'application :
/// ```dart
/// ConnectivityBanner(child: MaterialApp.router(...))
/// ```
class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key, required this.child});

  final Widget child;

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  bool _isOffline = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Écouter les changements de connectivité
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChanged);

    // Vérifier l'état initial
    Connectivity().checkConnectivity().then(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final offline = results.every((r) => r == ConnectivityResult.none);
    if (offline == _isOffline) return;

    setState(() => _isOffline = offline);

    if (offline) {
      _controller.forward();
    } else {
      // Laisser la bannière visible 1,5 s après le retour en ligne
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: _OfflineBanner(isOffline: _isOffline),
          ),
        ),
      ],
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.isOffline});

  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10 + bottomPadding,
        left: 16,
        right: 16,
      ),
      color: isOffline ? Colors.red.shade700 : Colors.green.shade600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isOffline
                ? 'common.no_internet'.tr()
                : 'common.back_online'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

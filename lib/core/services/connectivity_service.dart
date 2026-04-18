import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static Stream<bool> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.map(
        (results) => !results.contains(ConnectivityResult.none),
      );

  static Future<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityService.onConnectivityChanged,
      builder: (context, snapshot) {
        final online = snapshot.data ?? true;
        if (online) return const SizedBox.shrink();
        return Material(
          color: Colors.red.shade700,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Pas de connexion internet',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

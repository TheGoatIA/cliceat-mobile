import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/osrm_route_model.dart';

class NavigationCache {
  static const _key = 'nav_last_route';

  static Future<void> saveRoute(OsrmRoute route, String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({
      'orderId': orderId,
      'route': {
        'distance': route.distance,
        'duration': route.duration,
        'geometry': {
          'type': route.geometry.type,
          'coordinates': route.geometry.coordinates,
        },
        'legs': route.legs.map((l) => {
          'distance': l.distance,
          'duration': l.duration,
          'steps': l.steps.map((s) => {
            'distance': s.distance,
            'duration': s.duration,
            'instruction': s.instruction,
            'instructionFr': s.instructionFr,
            'name': s.name,
            'mode': s.mode,
            'maneuver': {
              'type': s.maneuver.type,
              'modifier': s.maneuver.modifier,
              'bearing_after': s.maneuver.bearingAfter,
            },
          }).toList(),
        }).toList(),
      },
      'savedAt': DateTime.now().toIso8601String(),
    }));
  }

  static Future<OsrmRoute?> loadRoute(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['orderId'] != orderId) return null;
      // Only use cache if less than 10 minutes old
      final savedAt = DateTime.parse(json['savedAt'] as String);
      if (DateTime.now().difference(savedAt).inMinutes > 10) return null;
      return OsrmRoute.fromJson(json['route'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

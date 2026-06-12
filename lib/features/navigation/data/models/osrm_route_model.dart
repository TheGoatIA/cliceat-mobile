class OsrmManeuver {
  final String type;
  final String? modifier;
  final double? bearingAfter;

  const OsrmManeuver({required this.type, this.modifier, this.bearingAfter});

  factory OsrmManeuver.fromJson(Map<String, dynamic> json) => OsrmManeuver(
    type: json['type'] as String? ?? 'straight',
    modifier: json['modifier'] as String?,
    bearingAfter: (json['bearing_after'] as num?)?.toDouble(),
  );
}

class OsrmStep {
  final double distance;
  final double duration;
  final String instruction;
  final String instructionFr;
  final OsrmManeuver maneuver;
  final String name;
  final String mode;

  const OsrmStep({
    required this.distance,
    required this.duration,
    required this.instruction,
    required this.instructionFr,
    required this.maneuver,
    required this.name,
    required this.mode,
  });

  factory OsrmStep.fromJson(Map<String, dynamic> json) => OsrmStep(
    distance: (json['distance'] as num).toDouble(),
    duration: (json['duration'] as num).toDouble(),
    instruction: json['instruction'] as String? ?? '',
    instructionFr: json['instructionFr'] as String? ?? '',
    maneuver: OsrmManeuver.fromJson(
      json['maneuver'] as Map<String, dynamic>? ?? {},
    ),
    name: json['name'] as String? ?? '',
    mode: json['mode'] as String? ?? 'driving',
  );

  String get displayInstruction =>
      instructionFr.isNotEmpty ? instructionFr : instruction;

  String get distanceLabel {
    if (distance >= 1000) return '${(distance / 1000).toStringAsFixed(1)} km';
    return '${distance.round()} m';
  }
}

class OsrmLeg {
  final double distance;
  final double duration;
  final List<OsrmStep> steps;

  const OsrmLeg({
    required this.distance,
    required this.duration,
    required this.steps,
  });

  factory OsrmLeg.fromJson(Map<String, dynamic> json) => OsrmLeg(
    distance: (json['distance'] as num).toDouble(),
    duration: (json['duration'] as num).toDouble(),
    steps: (json['steps'] as List<dynamic>? ?? [])
        .map((s) => OsrmStep.fromJson(s as Map<String, dynamic>))
        .toList(),
  );
}

class OsrmGeometry {
  final String type;
  final List<List<double>> coordinates;

  const OsrmGeometry({required this.type, required this.coordinates});

  factory OsrmGeometry.fromJson(Map<String, dynamic> json) {
    final rawCoords = json['coordinates'] as List<dynamic>? ?? [];
    return OsrmGeometry(
      type: json['type'] as String? ?? 'LineString',
      coordinates: rawCoords.map((c) {
        final pair = c as List<dynamic>;
        return [(pair[0] as num).toDouble(), (pair[1] as num).toDouble()];
      }).toList(),
    );
  }
}

class OsrmRoute {
  final double distance;
  final double duration;
  final double? durationOriginal;
  final double? trafficMultiplier;
  final OsrmGeometry geometry;
  final List<OsrmLeg> legs;

  const OsrmRoute({
    required this.distance,
    required this.duration,
    this.durationOriginal,
    this.trafficMultiplier,
    required this.geometry,
    required this.legs,
  });

  factory OsrmRoute.fromJson(Map<String, dynamic> json) => OsrmRoute(
    distance: (json['distance'] as num).toDouble(),
    duration: (json['duration'] as num).toDouble(),
    durationOriginal: (json['durationOriginal'] as num?)?.toDouble(),
    trafficMultiplier: (json['trafficMultiplier'] as num?)?.toDouble(),
    geometry: OsrmGeometry.fromJson(
      json['geometry'] as Map<String, dynamic>? ?? {},
    ),
    legs: (json['legs'] as List<dynamic>? ?? [])
        .map((l) => OsrmLeg.fromJson(l as Map<String, dynamic>))
        .toList(),
  );

  String get durationLabel {
    final minutes = (duration / 60).round();
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}min';
  }

  String get distanceLabel {
    if (distance >= 1000) return '${(distance / 1000).toStringAsFixed(1)} km';
    return '${distance.round()} m';
  }

  List<OsrmStep> get allSteps => legs.expand((l) => l.steps).toList();
}

class NavigationRouteResponse {
  final OsrmRoute route;
  final String? orderId;

  const NavigationRouteResponse({required this.route, this.orderId});

  factory NavigationRouteResponse.fromJson(Map<String, dynamic> json) {
    final routeData = json['route'] as Map<String, dynamic>;
    return NavigationRouteResponse(
      route: OsrmRoute.fromJson(routeData),
      orderId: json['orderId'] as String?,
    );
  }
}

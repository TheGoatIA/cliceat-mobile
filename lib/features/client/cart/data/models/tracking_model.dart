/// Real-time order tracking data.
class TrackingModel {
  final String orderId;
  final String status;
  final double? driverLat;
  final double? driverLng;
  final int? etaMinutes;
  final String? driverName;
  final String? driverPhone;
  final String? driverAvatar;

  const TrackingModel({
    required this.orderId,
    required this.status,
    this.driverLat,
    this.driverLng,
    this.etaMinutes,
    this.driverName,
    this.driverPhone,
    this.driverAvatar,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    final driver = json['driver'] as Map<String, dynamic>?;
    final location =
        json['location'] as Map<String, dynamic>? ??
        driver?['location'] as Map<String, dynamic>?;
    final coords = location?['coordinates'] as List<dynamic>?;

    return TrackingModel(
      orderId: json['orderId']?.toString() ?? json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      driverLat: coords != null && coords.length >= 2
          ? (coords[1] as num?)?.toDouble()
          : (json['driverLat'] as num?)?.toDouble(),
      driverLng: coords != null && coords.length >= 2
          ? (coords[0] as num?)?.toDouble()
          : (json['driverLng'] as num?)?.toDouble(),
      etaMinutes:
          (json['etaMinutes'] as num?)?.toInt() ??
          (json['eta'] as num?)?.toInt(),
      driverName: driver?['name']?.toString() ?? json['driverName']?.toString(),
      driverPhone:
          driver?['phone']?.toString() ?? json['driverPhone']?.toString(),
      driverAvatar:
          driver?['avatar']?.toString() ??
          driver?['photoUrl']?.toString() ??
          driver?['photo']?.toString() ??
          json['driverAvatar']?.toString(),
    );
  }
}

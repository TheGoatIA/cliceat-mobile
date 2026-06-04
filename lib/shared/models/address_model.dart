/// Delivery address model.
class AddressModel {
  final String id;
  final String address;
  final String? label;
  final double? lat;
  final double? lng;
  final String? city;

  const AddressModel({
    required this.id,
    required this.address,
    this.label,
    this.lat,
    this.lng,
    this.city,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>?;
    final coords = loc?['coordinates'] as List<dynamic>?;
    return AddressModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      address:
          json['address']?.toString() ??
          json['formattedAddress']?.toString() ??
          '',
      label: json['label']?.toString(),
      lat: (coords != null && coords.length >= 2)
          ? (coords[1] as num?)?.toDouble()
          : (json['lat'] as num?)?.toDouble(),
      lng: (coords != null && coords.length >= 2)
          ? (coords[0] as num?)?.toDouble()
          : (json['lng'] as num?)?.toDouble(),
      city: json['city']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'address': address,
    if (label != null) 'label': label,
    if (lat != null) 'lat': lat,
    if (lng != null) 'lng': lng,
    if (city != null) 'city': city,
  };
}

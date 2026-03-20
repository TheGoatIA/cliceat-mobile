import 'menu_item_model.dart';

/// Full restaurant model (includes menus when fetched from detail endpoint).
class RestaurantModel {
  final String id;
  final String name;
  final String? description;
  final String? cuisineType;
  final List<String> cuisines;
  final String? address;
  final String? city;
  final double lat;
  final double lng;
  final String? logoUrl;
  final String? coverImage;
  final double? rating;
  final bool isOpen;
  final double deliveryFee;
  final double? minOrder;
  final int? deliveryTimeMinutes;
  final List<MenuItemModel> menus;

  const RestaurantModel({
    required this.id,
    required this.name,
    this.description,
    this.cuisineType,
    this.cuisines = const [],
    this.address,
    this.city,
    this.lat = 0.0,
    this.lng = 0.0,
    this.logoUrl,
    this.coverImage,
    this.rating,
    this.isOpen = true,
    this.deliveryFee = 0.0,
    this.minOrder,
    this.deliveryTimeMinutes,
    this.menus = const [],
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>?;
    final coords = loc?['coordinates'] as List<dynamic>?;

    List<String> parsedCuisines = [];
    final rawCuisines = json['cuisines'] ?? json['cuisineTypes'];
    if (rawCuisines is List) {
      parsedCuisines = rawCuisines.map((c) => c.toString()).toList();
    }

    final rawMenus = json['menus'] as List<dynamic>? ?? [];

    return RestaurantModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      cuisineType: json['cuisineType']?.toString(),
      cuisines: parsedCuisines,
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      lat: (coords != null && coords.length >= 2)
          ? (coords[1] as num).toDouble()
          : (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (coords != null && coords.length >= 2)
          ? (coords[0] as num).toDouble()
          : (json['lng'] as num?)?.toDouble() ?? 0.0,
      logoUrl: json['logoUrl']?.toString() ?? json['logo']?.toString(),
      coverImage:
          json['coverImage']?.toString() ?? json['cover']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      isOpen: json['isOpen'] as bool? ?? true,
      deliveryFee:
          (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      minOrder: (json['minOrder'] as num?)?.toDouble(),
      deliveryTimeMinutes:
          (json['deliveryTimeMinutes'] as num?)?.toInt(),
      menus: rawMenus
          .whereType<Map<String, dynamic>>()
          .map(MenuItemModel.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        if (description != null) 'description': description,
        if (cuisineType != null) 'cuisineType': cuisineType,
        'cuisines': cuisines,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        'lat': lat,
        'lng': lng,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (coverImage != null) 'coverImage': coverImage,
        if (rating != null) 'rating': rating,
        'isOpen': isOpen,
        'deliveryFee': deliveryFee,
        if (minOrder != null) 'minOrder': minOrder,
        if (deliveryTimeMinutes != null)
          'deliveryTimeMinutes': deliveryTimeMinutes,
        'menus': menus.map((m) => m.toJson()).toList(),
      };
}

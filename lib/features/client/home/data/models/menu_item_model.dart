/// A single variation/option for a menu item (e.g. size, extra).
class MenuVariationModel {
  final String name;
  final double price;

  const MenuVariationModel({required this.name, required this.price});

  factory MenuVariationModel.fromJson(Map<String, dynamic> json) =>
      MenuVariationModel(
        name: json['name']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}

/// A restaurant menu item.
class MenuItemModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final String? category;
  final List<MenuVariationModel> variations;
  final bool isAvailable;

  const MenuItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.category,
    this.variations = const [],
    this.isAvailable = true,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final rawVariations =
        (json['variations'] as List<dynamic>? ?? []);
    return MenuItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image']?.toString() ?? json['imageUrl']?.toString(),
      category: json['category']?.toString(),
      variations: rawVariations
          .whereType<Map<String, dynamic>>()
          .map(MenuVariationModel.fromJson)
          .toList(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        if (description != null) 'description': description,
        'price': price,
        if (image != null) 'image': image,
        if (category != null) 'category': category,
        'variations': variations.map((v) => v.toJson()).toList(),
        'isAvailable': isAvailable,
      };
}

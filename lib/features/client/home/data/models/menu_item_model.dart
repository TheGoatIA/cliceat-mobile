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
  final String nameFr;
  final String nameEn;
  final String? descriptionFr;
  final String? descriptionEn;
  final double price;
  final String? image;
  final String? category;
  final List<MenuVariationModel> variations;
  final bool isAvailable;

  const MenuItemModel({
    required this.id,
    required this.nameFr,
    required this.nameEn,
    this.descriptionFr,
    this.descriptionEn,
    required this.price,
    this.image,
    this.category,
    this.variations = const [],
    this.isAvailable = true,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final rawVariations = (json['variations'] as List<dynamic>? ?? []);
    return MenuItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      nameFr: json['name_fr']?.toString() ?? json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? json['name']?.toString() ?? '',
      descriptionFr:
          json['description_fr']?.toString() ?? json['description']?.toString(),
      descriptionEn:
          json['description_en']?.toString() ?? json['description']?.toString(),
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

  String getName(String lang) => lang == 'en' ? nameEn : nameFr;
  String? getDescription(String lang) =>
      lang == 'en' ? descriptionEn : descriptionFr;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name_fr': nameFr,
    'name_en': nameEn,
    if (descriptionFr != null) 'description_fr': descriptionFr,
    if (descriptionEn != null) 'description_en': descriptionEn,
    'price': price,
    if (image != null) 'image': image,
    if (category != null) 'category': category,
    'variations': variations.map((v) => v.toJson()).toList(),
    'isAvailable': isAvailable,
  };
}

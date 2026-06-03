import 'menu_item_model.dart';

class MenuCategoryModel {
  final String id;
  final String nameFr;
  final String nameEn;
  final List<MenuItemModel> items;

  const MenuCategoryModel({
    required this.id,
    required this.nameFr,
    required this.nameEn,
    this.items = const [],
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return MenuCategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      nameFr: json['name_fr']?.toString() ?? json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? json['name']?.toString() ?? '',
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(MenuItemModel.fromJson)
          .toList(),
    );
  }

  String getName(String languageCode) {
    return languageCode == 'en' ? nameEn : nameFr;
  }
}

import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String imageUrl;
  final String? linkUrl;
  final String? title;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    this.linkUrl,
    this.title,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      linkUrl: json['linkUrl']?.toString(),
      title: json['title']?.toString() ?? 'Promo',
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, linkUrl, title];
}

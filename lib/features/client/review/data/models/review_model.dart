import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String orderId;
  final String restaurantId;
  final String? restaurantName;
  final String clientId;
  final String clientName;
  final int restaurantRating;
  final int? deliveryRating;
  final String? comment;
  final List<String> photos;
  final String? restaurantResponse;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.orderId,
    required this.restaurantId,
    this.restaurantName,
    required this.clientId,
    required this.clientName,
    required this.restaurantRating,
    this.deliveryRating,
    this.comment,
    this.photos = const [],
    this.restaurantResponse,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurantId'] is Map
        ? (json['restaurantId'] as Map).cast<String, dynamic>()
        : null;

    return ReviewModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      restaurantId: restaurant != null
          ? restaurant['_id']?.toString() ?? restaurant['id']?.toString() ?? ''
          : json['restaurantId']?.toString() ?? '',
      restaurantName:
          json['restaurantName']?.toString() ?? restaurant?['name']?.toString(),
      clientId: json['clientId']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? 'Utilisateur',
      restaurantRating: (json['restaurantRating'] as num?)?.toInt() ?? 5,
      deliveryRating: (json['deliveryRating'] as num?)?.toInt(),
      comment: json['comment']?.toString(),
      photos:
          (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? [],
      restaurantResponse: json['restaurantResponse']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    restaurantId,
    restaurantName,
    clientId,
    clientName,
    restaurantRating,
    deliveryRating,
    comment,
    photos,
    restaurantResponse,
    createdAt,
  ];
}

import 'package:cliceat_app/shared/models/address_model.dart';

/// Delivery mission assigned to a driver.
class MissionModel {
  final String id;
  final String status;
  final String? restaurantName;
  final String? restaurantAddress;
  final double? restaurantLat;
  final double? restaurantLng;
  final AddressModel? deliveryAddress;
  final double earnings;
  final String? clientName;
  final String? clientPhone;
  final DateTime? createdAt;
  final List<MissionItemModel> items;
  final String? paymentMethod;

  const MissionModel({
    required this.id,
    required this.status,
    this.restaurantName,
    this.restaurantAddress,
    this.restaurantLat,
    this.restaurantLng,
    this.deliveryAddress,
    this.earnings = 0.0,
    this.clientName,
    this.clientPhone,
    this.createdAt,
    this.items = const [],
    this.paymentMethod,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'] as Map<String, dynamic>?;
    final restaurantLoc =
        restaurant?['location'] as Map<String, dynamic>?;
    final restaurantCoords =
        restaurantLoc?['coordinates'] as List<dynamic>?;

    final deliveryAddrRaw =
        json['deliveryAddress'] as Map<String, dynamic>?;

    final client = json['client'] as Map<String, dynamic>?;

    final rawItems = json['items'] as List<dynamic>? ?? [];

    return MissionModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      restaurantName: restaurant?['name']?.toString(),
      restaurantAddress: restaurant?['address']?.toString(),
      restaurantLat: restaurantCoords != null && restaurantCoords.length >= 2
          ? (restaurantCoords[1] as num?)?.toDouble()
          : null,
      restaurantLng: restaurantCoords != null && restaurantCoords.length >= 2
          ? (restaurantCoords[0] as num?)?.toDouble()
          : null,
      deliveryAddress: deliveryAddrRaw != null
          ? AddressModel.fromJson(deliveryAddrRaw)
          : null,
      earnings: (json['deliveryEarnings'] as num?)?.toDouble() ??
          (json['earnings'] as num?)?.toDouble() ??
          0.0,
      clientName: client?['name']?.toString(),
      clientPhone: client?['phone']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(MissionItemModel.fromJson)
          .toList(),
      paymentMethod: json['paymentMethod']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'status': status,
        if (restaurantName != null) 'restaurantName': restaurantName,
        'earnings': earnings,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}

class MissionItemModel {
  final String name;
  final int quantity;

  const MissionItemModel({required this.name, required this.quantity});

  factory MissionItemModel.fromJson(Map<String, dynamic> json) {
    final item = json['item'] as Map<String, dynamic>? ?? json;
    return MissionItemModel(
      name: item['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

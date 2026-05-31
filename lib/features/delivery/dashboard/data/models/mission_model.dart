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
    // Supporte deux formats :
    // 1. Payload WebSocket `new_mission` du dispatch worker
    //    { orderId, orderNumber, restaurantName, restaurantAddress, restaurantLocation, total, deliveryFee, deliveryAddress, ... }
    // 2. Document ordre complet depuis l'API REST
    //    { _id, status, restaurantId: { name, address, location }, clientId: { name }, ... }

    // === ID ===
    final id = json['orderId']?.toString() ??
        json['_id']?.toString() ??
        json['id']?.toString() ??
        '';

    // === Restaurant (WebSocket payload) ===
    final restaurantName = json['restaurantName']?.toString();
    final restaurantAddress = json['restaurantAddress']?.toString();

    // restaurantLocation peut venir du payload WS: { type: 'Point', coordinates: [lng, lat] }
    final wsRestaurantLoc = json['restaurantLocation'] is Map
        ? (json['restaurantLocation'] as Map).cast<String, dynamic>()
        : null;
    final wsCoords = wsRestaurantLoc?['coordinates'] as List<dynamic>?;

    // Fallback: format API REST avec restaurant peuplé
    final restaurant = json['restaurant'] is Map
        ? (json['restaurant'] as Map).cast<String, dynamic>()
        : json['restaurantId'] is Map
            ? (json['restaurantId'] as Map).cast<String, dynamic>()
            : null;
    final restaurantLoc = restaurant?['location'] is Map
        ? (restaurant!['location'] as Map).cast<String, dynamic>()
        : null;
    final restCoords = restaurantLoc?['coordinates'] as List<dynamic>?;
 
    final effectiveCoords = wsCoords ?? restCoords;
    final resolvedRestaurantName =
        restaurantName ?? restaurant?['name']?.toString();
    final resolvedRestaurantAddress =
        restaurantAddress ?? restaurant?['address']?.toString();
 
    // === Delivery address ===
    final deliveryAddrRaw = json['deliveryAddress'] is Map
        ? (json['deliveryAddress'] as Map).cast<String, dynamic>()
        : null;
 
    // === Client ===
    final client = json['client'] is Map
        ? (json['client'] as Map).cast<String, dynamic>()
        : json['clientId'] is Map
            ? (json['clientId'] as Map).cast<String, dynamic>()
            : null;
 
    // === Items ===
    final dynamic itemsField = json['items'];
    final List<dynamic> rawItems = itemsField is List ? itemsField : [];
 
    // === Earnings : le payload WS envoie 'deliveryFee', l'API envoie 'deliveryEarnings' ===
    final earnings = (json['deliveryFee'] as num?)?.toDouble() ??
        (json['deliveryEarnings'] as num?)?.toDouble() ??
        (json['earnings'] as num?)?.toDouble() ??
        0.0;
 
    return MissionModel(
      id: id,
      status: json['status']?.toString() ?? 'pending',
      restaurantName: resolvedRestaurantName,
      restaurantAddress: resolvedRestaurantAddress,
      restaurantLat: effectiveCoords != null && effectiveCoords.length >= 2
          ? (effectiveCoords[1] as num?)?.toDouble()
          : null,
      restaurantLng: effectiveCoords != null && effectiveCoords.length >= 2
          ? (effectiveCoords[0] as num?)?.toDouble()
          : null,
      deliveryAddress: deliveryAddrRaw != null
          ? AddressModel.fromJson(deliveryAddrRaw)
          : null,
      earnings: earnings,
      clientName: client?['name']?.toString(),
      clientPhone: client?['phone']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      items: rawItems
          .map((e) => e is Map ? e.cast<String, dynamic>() : null)
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

import 'package:cliceat_app/shared/models/address_model.dart';

/// One item within an order.
class OrderItemModel {
  final String itemId;
  final String name;
  final int quantity;
  final double price;
  final String? variation;

  const OrderItemModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.variation,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // item may be nested or flat
    final item = json['item'] as Map<String, dynamic>? ?? json;
    return OrderItemModel(
      itemId: item['_id']?.toString() ?? item['id']?.toString() ?? '',
      name: item['name']?.toString() ?? json['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: (json['price'] as num?)?.toDouble() ??
          (item['price'] as num?)?.toDouble() ??
          0.0,
      variation: json['variation']?.toString() ??
          json['selectedVariation']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'name': name,
        'quantity': quantity,
        'price': price,
        if (variation != null) 'variation': variation,
      };
}

/// Full order model.
class OrderModel {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final String? restaurantLogo;
  final List<OrderItemModel> items;
  final double total;
  final double? deliveryFee;
  final String status;
  final String? paymentUrl;
  final String? paymentMethod;
  final AddressModel? deliveryAddress;
  final String? notes;
  final DateTime? createdAt;
  final double? rating;
  final String? invoiceUrl;

  const OrderModel({
    required this.id,
    this.restaurantId,
    this.restaurantName,
    this.restaurantLogo,
    this.items = const [],
    required this.total,
    this.deliveryFee,
    required this.status,
    this.paymentUrl,
    this.paymentMethod,
    this.deliveryAddress,
    this.notes,
    this.createdAt,
    this.rating,
    this.invoiceUrl,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurant'] as Map<String, dynamic>?;
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final addrRaw = json['deliveryAddress'] as Map<String, dynamic>?;

    final paymentInfo = json['payment'] as Map<String, dynamic>?;
    final paymentUrl =
        json['paymentUrl'] as String? ?? paymentInfo?['paymentUrl'] as String?;

    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      restaurantId: restaurant?['_id']?.toString() ??
          restaurant?['id']?.toString() ??
          json['restaurantId']?.toString(),
      restaurantName: restaurant?['name']?.toString() ??
          json['restaurantName']?.toString(),
      restaurantLogo: restaurant?['logo']?.toString() ??
          restaurant?['logoUrl']?.toString() ??
          json['restaurantLogo']?.toString() ??
          json['restaurantLogoUrl']?.toString(),
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(OrderItemModel.fromJson)
          .toList(),
      total: (json['total'] as num?)?.toDouble() ??
          (json['totalAmount'] as num?)?.toDouble() ??
          0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      status: json['status']?.toString() ?? 'pending',
      paymentUrl: paymentUrl,
      paymentMethod: json['paymentMethod']?.toString(),
      deliveryAddress:
          addrRaw != null ? AddressModel.fromJson(addrRaw) : null,
      notes: json['notes']?.toString() ?? json['deliveryNotes']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      invoiceUrl: json['invoiceUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        if (restaurantId != null) 'restaurantId': restaurantId,
        if (restaurantName != null) 'restaurantName': restaurantName,
        if (restaurantLogo != null) 'restaurantLogo': restaurantLogo,
        'items': items.map((i) => i.toJson()).toList(),
        'total': total,
        if (deliveryFee != null) 'deliveryFee': deliveryFee,
        'status': status,
        if (paymentUrl != null) 'paymentUrl': paymentUrl,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        if (notes != null) 'notes': notes,
        if (notes != null) 'deliveryNotes': notes,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (rating != null) 'rating': rating,
        if (invoiceUrl != null) 'invoiceUrl': invoiceUrl,
      };
}

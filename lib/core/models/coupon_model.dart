/// Promotional coupon / discount code.
class CouponModel {
  final String id;
  final String code;
  final double discount;
  /// 'percentage' or 'fixed'
  final String discountType;
  final double? maxDiscount;
  final DateTime? expiresAt;
  final bool isValid;

  const CouponModel({
    required this.id,
    required this.code,
    required this.discount,
    this.discountType = 'fixed',
    this.maxDiscount,
    this.expiresAt,
    this.isValid = true,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ??
        json['coupon'] as Map<String, dynamic>? ??
        json;
    return CouponModel(
      id: data['_id']?.toString() ?? data['id']?.toString() ?? '',
      code: data['code']?.toString() ?? '',
      discount: (data['discount'] as num?)?.toDouble() ??
          (data['value'] as num?)?.toDouble() ??
          0.0,
      discountType: data['discountType']?.toString() ??
          data['type']?.toString() ??
          'fixed',
      maxDiscount: (data['maxDiscount'] as num?)?.toDouble(),
      expiresAt: data['expiresAt'] != null
          ? DateTime.tryParse(data['expiresAt'].toString())
          : null,
      isValid: data['isValid'] as bool? ?? true,
    );
  }

  /// Computes the actual discount amount given a subtotal.
  double computeDiscount(double subtotal) {
    if (discountType == 'percentage') {
      final pct = subtotal * discount / 100;
      return maxDiscount != null && pct > maxDiscount!
          ? maxDiscount!
          : pct;
    }
    return discount;
  }
}

/// Marketing banner from the API.
class BannerModel {
  final String id;
  final String imageUrl;
  final String? targetUrl;
  final String? title;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    this.targetUrl,
    this.title,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ??
            json['image']?.toString() ??
            '',
        targetUrl: json['targetUrl']?.toString() ?? json['url']?.toString(),
        title: json['title']?.toString(),
      );
}

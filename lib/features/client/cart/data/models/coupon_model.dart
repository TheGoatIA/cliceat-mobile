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

  CouponModel copyWith({
    String? id,
    String? code,
    double? discount,
    String? discountType,
    double? maxDiscount,
    DateTime? expiresAt,
    bool? isValid,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      expiresAt: expiresAt ?? this.expiresAt,
      isValid: isValid ?? this.isValid,
    );
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final data =
        json['data'] as Map<String, dynamic>? ??
        json['coupon'] as Map<String, dynamic>? ??
        json;
    return CouponModel(
      id: data['_id']?.toString() ?? data['id']?.toString() ?? '',
      code: data['code']?.toString() ?? '',
      discount:
          (data['discount'] as num?)?.toDouble() ??
          (data['value'] as num?)?.toDouble() ??
          0.0,
      discountType:
          data['discountType']?.toString() ??
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
      return maxDiscount != null && pct > maxDiscount! ? maxDiscount! : pct;
    }
    return discount;
  }
}

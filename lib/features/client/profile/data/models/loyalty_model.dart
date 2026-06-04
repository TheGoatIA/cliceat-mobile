/// User loyalty points and tier.
class LoyaltyModel {
  final int points;
  final double discountPercent;
  final String? tier;
  final int? pointsToNextTier;

  const LoyaltyModel({
    this.points = 0,
    this.discountPercent = 0.0,
    this.tier,
    this.pointsToNextTier,
  });

  factory LoyaltyModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return LoyaltyModel(
      points: (data['points'] as num?)?.toInt() ?? 0,
      discountPercent: (data['discountPercent'] as num?)?.toDouble() ?? 0.0,
      tier: data['tier']?.toString(),
      pointsToNextTier: (data['pointsToNextTier'] as num?)?.toInt(),
    );
  }
}

import 'package:equatable/equatable.dart';

class ReferralStatsModel extends Equatable {
  final int totalReferrals;
  final double totalEarned;
  final double pendingBonus;
  final String referralCode;

  const ReferralStatsModel({
    required this.totalReferrals,
    required this.totalEarned,
    required this.pendingBonus,
    required this.referralCode,
  });

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatsModel(
      totalReferrals: (json['totalReferrals'] as num?)?.toInt() ?? 0,
      totalEarned: (json['totalEarned'] as num?)?.toDouble() ?? 0.0,
      pendingBonus: (json['pendingBonus'] as num?)?.toDouble() ?? 0.0,
      referralCode: json['referralCode']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    totalReferrals,
    totalEarned,
    pendingBonus,
    referralCode,
  ];
}

/// Daily earnings breakdown entry.
class DailyEarningsModel {
  final DateTime date;
  final double amount;
  final int deliveries;

  const DailyEarningsModel({
    required this.date,
    required this.amount,
    required this.deliveries,
  });

  factory DailyEarningsModel.fromJson(Map<String, dynamic> json) =>
      DailyEarningsModel(
        date: json['date'] != null
            ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
            : DateTime.now(),
        amount:
            (json['amount'] as num?)?.toDouble() ??
            (json['earnings'] as num?)?.toDouble() ??
            0.0,
        deliveries:
            (json['deliveries'] as num?)?.toInt() ??
            (json['count'] as num?)?.toInt() ??
            0,
      );
}

/// Driver earnings summary.
class EarningsModel {
  final double today;
  final double thisWeek;
  final double thisMonth;
  final int todayDeliveries;
  final int weekDeliveries;
  final List<DailyEarningsModel> dailyBreakdown;

  const EarningsModel({
    this.today = 0.0,
    this.thisWeek = 0.0,
    this.thisMonth = 0.0,
    this.todayDeliveries = 0,
    this.weekDeliveries = 0,
    this.dailyBreakdown = const [],
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? json;
    final rawDaily =
        json['daily'] as List<dynamic>? ??
        json['dailyBreakdown'] as List<dynamic>? ??
        [];

    return EarningsModel(
      today: (summary['today'] as num?)?.toDouble() ?? 0.0,
      thisWeek:
          (summary['thisWeek'] as num?)?.toDouble() ??
          (summary['week'] as num?)?.toDouble() ??
          0.0,
      thisMonth:
          (summary['thisMonth'] as num?)?.toDouble() ??
          (summary['month'] as num?)?.toDouble() ??
          0.0,
      todayDeliveries: (summary['todayDeliveries'] as num?)?.toInt() ?? 0,
      weekDeliveries: (summary['weekDeliveries'] as num?)?.toInt() ?? 0,
      dailyBreakdown: rawDaily
          .whereType<Map<String, dynamic>>()
          .map(DailyEarningsModel.fromJson)
          .toList(),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:cliceat_app/di/injection.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/earnings_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/driver_repository.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  EarningsModel? _earnings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    setState(() => _loading = true);
    final result = await getIt<DriverRepository>().getEarnings();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (earnings) => setState(() {
        _earnings = earnings;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.earnings_title'.tr()),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _loadEarnings();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => _loading = true);
                await _loadEarnings();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(theme),
                    const SizedBox(height: 24),
                    _buildBarChart(theme),
                    const SizedBox(height: 24),
                    _buildPeriodBreakdown(theme),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    final todayEarnings = _earnings?.today ?? 0.0;
    final weekEarnings = _earnings?.thisWeek ?? 0.0;
    final monthEarnings = _earnings?.thisMonth ?? 0.0;
    final totalDeliveries = _earnings?.todayDeliveries ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.earnings_summary'.tr(),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'delivery.todays_earnings'.tr(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '${todayEarnings.toStringAsFixed(0)} FCFA',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatChip(Icons.delivery_dining,
                        '$totalDeliveries', 'delivery.deliveries'.tr()),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                theme,
                'delivery.this_week'.tr(),
                '${weekEarnings.toStringAsFixed(0)} FCFA',
                Icons.calendar_view_week,
                theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                theme,
                'delivery.this_month'.tr(),
                '${monthEarnings.toStringAsFixed(0)} FCFA',
                Icons.calendar_month,
                theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Renders a bar chart of the breakdown data using CustomPainter.
  Widget _buildBarChart(ThemeData theme) {
    final breakdown = _earnings?.dailyBreakdown ?? [];
    if (breakdown.isEmpty) return const SizedBox.shrink();

    final amounts = breakdown.map((e) => e.amount).toList();
    final labels = breakdown.map((e) {
          try {
            return '${e.date.day}/${e.date.month}';
          } catch (_) {
            return '';
          }
        }).toList();

    return Card(
      elevation: 1,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'delivery.earnings_chart'.tr(),
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _EarningsBarChartPainter(
                  amounts: amounts.map((a) => a as num).toList(),
                  labels: labels,
                  barColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.onSurfaceVariant,
                  gridColor: theme.dividerColor,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style:
                const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildMetricCard(ThemeData theme, String label, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodBreakdown(ThemeData theme) {
    final breakdown = _earnings?.dailyBreakdown ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.daily_breakdown'.tr(),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (breakdown.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.bar_chart,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'delivery.no_earnings_data'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...breakdown.map((item) {
            final dateLabel =
                '${item.date.day}/${item.date.month}/${item.date.year}';
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.today,
                      color: theme.colorScheme.primary, size: 20),
                ),
                title: Text(dateLabel,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                    '${item.deliveries} ${'delivery.deliveries'.tr()}'),
                trailing: Text(
                  '${item.amount.toStringAsFixed(0)} FCFA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

/// CustomPainter that draws a simple bar chart.
class _EarningsBarChartPainter extends CustomPainter {
  final List<num> amounts;
  final List<String> labels;
  final Color barColor;
  final Color labelColor;
  final Color gridColor;

  _EarningsBarChartPainter({
    required this.amounts,
    required this.labels,
    required this.barColor,
    required this.labelColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amounts.isEmpty) return;

    const labelHeight = 20.0;
    const topPadding = 12.0;
    final chartHeight = size.height - labelHeight - topPadding;
    final maxValue = amounts.fold<num>(0, math.max).toDouble();
    if (maxValue == 0) return;

    final barWidth = (size.width / amounts.length) * 0.6;
    final gap = (size.width / amounts.length) * 0.4;
    final halfGap = gap / 2;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    // 4 horizontal grid lines
    for (int i = 1; i <= 4; i++) {
      final y = topPadding + chartHeight * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < amounts.length; i++) {
      final fraction = amounts[i].toDouble() / maxValue;
      final barH = fraction * chartHeight;
      final x = i * (size.width / amounts.length) + halfGap;
      final top = topPadding + chartHeight - barH;

      // Bar with rounded top
      final barPaint = Paint()
        ..color = barColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;
      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, top, barWidth, barH),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rrect, barPaint);

      // Label below bar
      if (i < labels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: TextStyle(
                color: labelColor,
                fontSize: 9,
                fontWeight: FontWeight.w500),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: barWidth + gap);
        tp.paint(canvas,
            Offset(x + barWidth / 2 - tp.width / 2, size.height - labelHeight + 4));
      }
    }
  }

  @override
  bool shouldRepaint(_EarningsBarChartPainter old) =>
      old.amounts != amounts;
}

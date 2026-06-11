import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
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
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'delivery.earnings_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.ink),
            onPressed: () {
              setState(() => _loading = true);
              _loadEarnings();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            )
          : RefreshIndicator(
              color: AppTheme.primaryRed,
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
                    _buildSummaryCards(),
                    const SizedBox(height: 24),
                    _buildBarChart(),
                    const SizedBox(height: 24),
                    _buildPeriodBreakdown(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    final todayEarnings = _earnings?.today ?? 0.0;
    final weekEarnings = _earnings?.thisWeek ?? 0.0;
    final monthEarnings = _earnings?.thisMonth ?? 0.0;
    final totalDeliveries = _earnings?.todayDeliveries ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.earnings_summary'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppTheme.primaryRed, AppTheme.redDeep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'delivery.todays_earnings'.tr(),
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${todayEarnings.toStringAsFixed(0)} FCFA',
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip(
                    Icons.delivery_dining,
                    '$totalDeliveries',
                    'delivery.deliveries'.tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                label: 'delivery.this_week'.tr(),
                value: '${weekEarnings.toStringAsFixed(0)} FCFA',
                icon: Icons.calendar_view_week,
                iconBg: AppTheme.greenSoft,
                iconColor: AppTheme.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                label: 'delivery.this_month'.tr(),
                value: '${monthEarnings.toStringAsFixed(0)} FCFA',
                icon: Icons.calendar_month,
                iconBg: AppTheme.honeySoft,
                iconColor: AppTheme.honey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    final breakdown = _earnings?.dailyBreakdown ?? [];
    if (breakdown.isEmpty) return const SizedBox.shrink();

    final amounts = breakdown.map((e) => e.amount).toList();
    final labels = breakdown.map((e) {
      try {
        return '${e.date.day}/${e.date.month}';
      } catch (_) {
        // Date parse failure for chart label — return empty string to skip tick
        return '';
      }
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'delivery.earnings_chart'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppTheme.ink,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _EarningsBarChartPainter(
                amounts: amounts.map((a) => a as num).toList(),
                labels: labels,
                barColor: AppTheme.primaryRed,
                labelColor: AppTheme.muted,
                gridColor: AppTheme.lineSoft,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.bricolageGrotesque(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodBreakdown() {
    final breakdown = _earnings?.dailyBreakdown ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.daily_breakdown'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        if (breakdown.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(
                    Icons.bar_chart,
                    size: 64,
                    color: AppTheme.mutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'delivery.no_earnings_data'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.muted,
                    ),
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
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.lineSoft),
                boxShadow: AppTheme.shadowSm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.redSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.today,
                      color: AppTheme.primaryRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateLabel,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppTheme.ink,
                          ),
                        ),
                        Text(
                          '${item.deliveries} ${'delivery.deliveries'.tr()}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.amount.toStringAsFixed(0)} FCFA',
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}

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
    for (int i = 1; i <= 4; i++) {
      final y = topPadding + chartHeight * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < amounts.length; i++) {
      final fraction = amounts[i].toDouble() / maxValue;
      final barH = fraction * chartHeight;
      final x = i * (size.width / amounts.length) + halfGap;
      final top = topPadding + chartHeight - barH;

      final barPaint = Paint()
        ..color = barColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;
      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, top, barWidth, barH),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rrect, barPaint);

      if (i < labels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: TextStyle(
              color: labelColor,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: barWidth + gap);
        tp.paint(
          canvas,
          Offset(
            x + barWidth / 2 - tp.width / 2,
            size.height - labelHeight + 4,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_EarningsBarChartPainter old) => old.amounts != amounts;
}

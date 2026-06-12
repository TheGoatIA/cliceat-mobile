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

  Map<String, dynamic>? _ranking;
  Map<String, dynamic>? _goal;
  bool _businessLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
    _loadBusiness();
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

  Future<void> _loadBusiness() async {
    setState(() => _businessLoading = true);
    final rankRes = await getIt<DriverRepository>().getRanking();
    final goalRes = await getIt<DriverRepository>().getGoal();
    if (!mounted) return;
    setState(() {
      rankRes.fold((_) {}, (r) => _ranking = r);
      goalRes.fold((_) {}, (g) => _goal = g);
      _businessLoading = false;
    });
  }

  Future<void> _showGoalDialog() async {
    final controller = TextEditingController(
      text: (_goal?['amount'] as num?)?.toInt().toString() ?? '',
    );
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'delivery.goal_dialog_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'delivery.goal_placeholder'.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.primaryRed,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'common.cancel'.tr(),
              style: GoogleFonts.inter(color: AppTheme.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val > 0) Navigator.pop(ctx, val);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'delivery.goal_save'.tr(),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      final saveRes = await getIt<DriverRepository>().setGoal(result);
      if (!mounted) return;
      saveRes.fold(
        (err) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.message),
            backgroundColor: AppTheme.primaryRed,
          ),
        ),
        (_) {
          setState(() {
            _goal = {...?_goal, 'amount': result};
          });
        },
      );
    }
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
              _loadEarnings();
              _loadBusiness();
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
                    if (!_businessLoading) ...[
                      if (_ranking != null) ...[
                        _buildMotivationalBanner(),
                        const SizedBox(height: 12),
                        _buildRankingCard(),
                        const SizedBox(height: 12),
                      ],
                      if (_goal != null) ...[
                        _buildGoalCard(),
                        const SizedBox(height: 24),
                      ],
                    ],
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

  Widget _buildMotivationalBanner() {
    final message = _ranking?['message'] as String?;
    if (message == null || message.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('💬', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingCard() {
    final rank = (_ranking?['rank'] as num?)?.toInt() ?? 0;
    final total = (_ranking?['total'] as num?)?.toInt() ?? 1;
    final city = _ranking?['city'] as String? ?? 'Douala';
    final percent = total > 0 ? ((rank / total) * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.honeySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppTheme.honey,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'delivery.ranking_title'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                    Text(
                      'delivery.ranking_top'.tr(
                        namedArgs: {'percent': '$percent', 'city': city},
                      ),
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? (total - rank + 1) / total : 0,
              minHeight: 8,
              backgroundColor: AppTheme.lineSoft,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.honey),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'delivery.ranking_drivers'.tr(
              namedArgs: {'rank': '$rank', 'total': '$total'},
            ),
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard() {
    final goalAmount = (_goal?['amount'] as num?)?.toDouble() ?? 0;
    final current = (_goal?['current'] as num?)?.toDouble() ?? 0;
    final achieved = goalAmount > 0 && current >= goalAmount;
    final progress = goalAmount > 0
        ? (current / goalAmount).clamp(0.0, 1.0)
        : 0.0;
    final remaining = (goalAmount - current).clamp(0.0, double.infinity);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.greenSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.track_changes,
                  color: AppTheme.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'delivery.goal_title'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppTheme.ink,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showGoalDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: Text(
                    goalAmount > 0
                        ? 'delivery.goal_modify'.tr()
                        : 'delivery.goal_set'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (achieved) ...[
            Text(
              'delivery.goal_achieved'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppTheme.green,
              ),
            ),
          ] else if (goalAmount > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppTheme.lineSoft,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.green),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'delivery.goal_progress'.tr(
                namedArgs: {
                  'current': current.toStringAsFixed(0),
                  'goal': goalAmount.toStringAsFixed(0),
                },
              ),
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
            ),
            const SizedBox(height: 2),
            Text(
              'Il te reste ${remaining.toStringAsFixed(0)} XAF',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.inkSoft,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            Text(
              'delivery.goal_set'.tr(),
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
            ),
          ],
        ],
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

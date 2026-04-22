import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/models/mission_model.dart';
import 'package:cliceat_app/features/delivery/dashboard/data/repositories/driver_repository.dart';

class DeliveryHistoryPage extends StatefulWidget {
  const DeliveryHistoryPage({super.key});

  @override
  State<DeliveryHistoryPage> createState() => _DeliveryHistoryPageState();
}

class _DeliveryHistoryPageState extends State<DeliveryHistoryPage> {
  List<MissionModel> _missions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final result = await getIt<DriverRepository>().getActiveMissions();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (missions) => setState(() {
        _missions = missions;
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
          'delivery.history_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primaryRed, strokeWidth: 2))
          : RefreshIndicator(
              color: AppTheme.primaryRed,
              onRefresh: () async {
                setState(() => _loading = true);
                await _loadHistory();
              },
              child: _missions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.bgWarm,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(Icons.history,
                                size: 36, color: AppTheme.muted),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'delivery.no_history'.tr(),
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: _missions.length,
                      itemBuilder: (context, index) {
                        return _buildMissionCard(_missions[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildMissionCard(MissionModel mission) {
    final formattedDate = mission.createdAt != null
        ? '${mission.createdAt!.day.toString().padLeft(2, '0')}/'
            '${mission.createdAt!.month.toString().padLeft(2, '0')}/'
            '${mission.createdAt!.year}'
        : '';

    final statusColor = _statusColor(mission.status);
    final statusLabel = _statusLabel(mission.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mission.restaurantName ?? 'Restaurant',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (formattedDate.isNotEmpty) ...[
                const Icon(Icons.calendar_today,
                    size: 14, color: AppTheme.mutedLight),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
                ),
                const SizedBox(width: 16),
              ],
              const Icon(Icons.delivery_dining,
                  size: 14, color: AppTheme.primaryRed),
              const SizedBox(width: 4),
              Text(
                '${'delivery.your_earnings'.tr()}: '
                '${mission.earnings.toStringAsFixed(0)} FCFA',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppTheme.green;
      case 'cancelled':
        return AppTheme.errorColor;
      case 'pending':
        return AppTheme.honey;
      case 'picked_up':
      case 'in_transit':
        return AppTheme.primaryRed;
      default:
        return AppTheme.muted;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'delivery.status_delivered'.tr();
      case 'cancelled':
        return 'delivery.status_cancelled'.tr();
      case 'pending':
        return 'delivery.status_pending'.tr();
      case 'picked_up':
        return 'delivery.status_picked_up'.tr();
      case 'in_transit':
        return 'delivery.status_in_transit'.tr();
      default:
        return status;
    }
  }
}

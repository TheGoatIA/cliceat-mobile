import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            )
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
                            child: const Icon(
                              Icons.history,
                              size: 36,
                              color: AppTheme.muted,
                            ),
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

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showMissionDetailsBottomSheet(context, mission);
      },
      child: Container(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (formattedDate.isNotEmpty) ...[
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppTheme.mutedLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.muted,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                const Icon(
                  Icons.delivery_dining,
                  size: 14,
                  color: AppTheme.primaryRed,
                ),
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
      ),
    );
  }

  void _showMissionDetailsBottomSheet(
    BuildContext context,
    MissionModel mission,
  ) {
    final formattedDate = mission.createdAt != null
        ? '${mission.createdAt!.day.toString().padLeft(2, '0')}/'
              '${mission.createdAt!.month.toString().padLeft(2, '0')}/'
              '${mission.createdAt!.year} à ${mission.createdAt!.hour.toString().padLeft(2, '0')}:'
              '${mission.createdAt!.minute.toString().padLeft(2, '0')}'
        : 'Indisponible';

    final shortId = mission.id.length > 8
        ? mission.id.substring(mission.id.length - 8).toUpperCase()
        : mission.id.toUpperCase();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Grab handle
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.lineSoft,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: _statusColor(
                            mission.status,
                          ).withValues(alpha: 0.1),
                          child: Icon(
                            mission.status.toLowerCase() == 'delivered'
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            color: _statusColor(mission.status),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commande #$shortId',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: AppTheme.ink,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              mission.status,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _statusLabel(mission.status),
                            style: GoogleFonts.inter(
                              color: _statusColor(mission.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppTheme.lineSoft),

                  // Content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Restaurant Section
                        _buildSectionHeader('Restaurant'),
                        _buildDetailTile(
                          icon: Icons.storefront_rounded,
                          title: mission.restaurantName ?? 'Restaurant inconnu',
                          subtitle:
                              mission.restaurantAddress ?? 'Adresse inconnue',
                        ),
                        const SizedBox(height: 20),

                        // Client Section
                        _buildSectionHeader('Client'),
                        _buildDetailTile(
                          icon: Icons.person_rounded,
                          title: mission.clientName ?? 'Client anonyme',
                          subtitle:
                              mission.deliveryAddress?.address ??
                              'Adresse de livraison inconnue',
                        ),
                        if (mission.clientPhone != null &&
                            mission.clientPhone!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildDetailTile(
                            icon: Icons.phone_android_rounded,
                            title: 'Téléphone',
                            subtitle: mission.clientPhone!,
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Order Items Section
                        if (mission.items.isNotEmpty) ...[
                          _buildSectionHeader('Articles commandés'),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.bgWarm.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.lineSoft),
                            ),
                            child: Column(
                              children: mission.items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.ink,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'x${item.quantity}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Payment & Earnings Section
                        _buildSectionHeader('Détails financiers'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mode de paiement',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.muted,
                              ),
                            ),
                            Text(
                              mission.paymentMethod == 'cash'
                                  ? 'Espèces à la livraison'
                                  : mission.paymentMethod == 'orange_money'
                                  ? 'Orange Money'
                                  : mission.paymentMethod == 'mtn_momo'
                                  ? 'MTN Mobile Money'
                                  : mission.paymentMethod == 'wallet'
                                  ? 'Portefeuille ClicEat'
                                  : 'Paiement en ligne',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vos gains de livraison',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.muted,
                              ),
                            ),
                            Text(
                              '${mission.earnings.toStringAsFixed(0)} FCFA',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.bricolageGrotesque(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppTheme.muted,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppTheme.lineSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.inkSoft, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
              ),
            ],
          ),
        ),
      ],
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

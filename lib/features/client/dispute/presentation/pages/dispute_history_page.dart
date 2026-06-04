import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/dispute/presentation/bloc/dispute_cubit.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

class DisputeHistoryPage extends StatelessWidget {
  const DisputeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DisputeCubit>()..loadDisputes(),
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'dispute.history_title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: BlocBuilder<DisputeCubit, DisputeState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryRed,
                  strokeWidth: 2,
                ),
              ),
              loaded: (disputes) {
                if (disputes.isEmpty) {
                  return Center(
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
                            Icons.gavel_outlined,
                            size: 36,
                            color: AppTheme.muted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'dispute.no_history'.tr(),
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: disputes.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final d = disputes[index];
                    final status = d['status'] as String? ?? 'pending';
                    final date =
                        DateTime.tryParse(d['createdAt'] ?? '') ??
                        DateTime.now();
                    final rawReason = d['reason']?.toString() ?? 'other';
                    final reasonKey = switch (rawReason) {
                      'missing_item' => 'dispute.reason_missing_item',
                      'delivery_delay' => 'dispute.reason_late_delivery',
                      'bad_quality' => 'dispute.reason_quality_issue',
                      _ => 'dispute.reason_other',
                    };

                    final orderObj = d['orderId'];
                    String orderDisplayId = '';
                    if (orderObj is Map) {
                      orderDisplayId =
                          orderObj['orderNumber']?.toString() ??
                          orderObj['_id']?.toString().substring(0, 8) ??
                          '';
                    } else if (orderObj != null) {
                      final str = orderObj.toString();
                      orderDisplayId = str.length > 8
                          ? str.substring(0, 8)
                          : str;
                    }

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'dispute.order_id_short'.tr(
                                  args: [orderDisplayId],
                                ),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppTheme.ink,
                                ),
                              ),
                              _buildStatusChip(status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reasonKey.tr(),
                            style: GoogleFonts.inter(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.inkSoft,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm').format(date),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.mutedLight,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (msg) => Center(
                child: Text(
                  msg.tr(),
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryRed,
                    fontSize: 14,
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = AppTheme.statusPending;
    String label = 'dispute.status_pending';

    if (status == 'resolved') {
      color = AppTheme.green;
      label = 'dispute.status_resolved';
    } else if (status == 'rejected') {
      color = AppTheme.errorColor;
      label = 'dispute.status_rejected';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label.tr(),
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

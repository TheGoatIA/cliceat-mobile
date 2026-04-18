import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: AppBar(
          title: Text('dispute.history_title'.tr()),
        ),
        body: BlocBuilder<DisputeCubit, DisputeState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (disputes) {
                if (disputes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.gavel_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('dispute.no_history'.tr()),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: disputes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final d = disputes[index];
                    final status = d['status'] as String? ?? 'pending';
                    final date = DateTime.tryParse(d['createdAt'] ?? '') ?? DateTime.now();

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'dispute.order_id_short'.tr(args: [d['orderId']?.toString().substring(0, 8) ?? '']),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _buildStatusChip(status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            d['reason']?.toString().tr() ?? '',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm').format(date),
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (msg) => Center(child: Text(msg)),
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
      color = AppTheme.successColor;
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
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

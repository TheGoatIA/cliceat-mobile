import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/empty_state.dart';
import '../cubit/notification_cubit.dart';
import '../../data/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.ink, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'notifications.title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.lineSoft, height: 1),
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryRed),
            ),
            loading: () => _buildShimmerLoading(),
            error: (message) => Center(
              child: EmptyState(
                title: 'common.error'.tr(),
                subtitle: message,
                icon: Icons.error_outline_rounded,
                actionLabel: 'common.retry'.tr(),
                onAction: () => context.read<NotificationCubit>().loadNotifications(),
              ),
            ),
            loaded: (notifications) {
              if (notifications.isEmpty) {
                return Center(
                  child: EmptyState(
                    title: 'notifications.empty_title'.tr(),
                    subtitle: 'notifications.empty_subtitle'.tr(),
                    icon: Icons.notifications_none_rounded,
                  ),
                );
              }
              return RefreshIndicator(
                color: AppTheme.primaryRed,
                onRefresh: () => context.read<NotificationCubit>().loadNotifications(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return _buildNotificationItem(context, item);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel item) {
    final cubit = context.read<NotificationCubit>();
    final dateStr = DateFormat('dd MMM, HH:mm', 'fr').format(item.createdAt);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cubit.delete(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.primaryRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () {
          if (!item.isRead) {
            cubit.markAsRead(item.id);
          }
          // Si redirection spécifique à faire selon item.data['type']
          if (item.data != null) {
            final type = item.data!['type']?.toString();
            final orderId = item.data!['orderId']?.toString();
            if (orderId != null && (type == 'new_mission' || type == 'order_status' || type == 'delivery')) {
              context.push('/client/tracking/$orderId');
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : AppTheme.bgWarm.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead ? AppTheme.lineSoft : AppTheme.primaryRed.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: item.isRead ? null : AppTheme.shadowSm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.isRead ? AppTheme.bgWarm : AppTheme.primaryRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(item.data?['type']?.toString()),
                  color: item.isRead ? AppTheme.muted : AppTheme.primaryRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                              color: AppTheme.ink,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: item.isRead ? AppTheme.muted : AppTheme.ink.withValues(alpha: 0.8),
                        fontWeight: item.isRead ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'new_mission':
      case 'new_order':
        return Icons.local_shipping_outlined;
      case 'order_status':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.account_balance_wallet_outlined;
      case 'promotion':
        return Icons.local_fire_department_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Container(
        height: 96,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lineSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bgWarm,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 12, width: 120, color: AppTheme.bgWarm),
                  const SizedBox(height: 8),
                  Container(height: 10, width: double.infinity, color: AppTheme.bgWarm),
                  const SizedBox(height: 6),
                  Container(height: 8, width: 60, color: AppTheme.bgWarm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cliceat_app/features/auth/presentation/bloc/auth_bloc.dart';
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.ink,
            size: 20,
          ),
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
                onAction: () =>
                    context.read<NotificationCubit>().loadNotifications(),
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
                onRefresh: () =>
                    context.read<NotificationCubit>().loadNotifications(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
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
    final dateStr = DateFormat(
      'dd MMM, HH:mm',
      context.locale.toString(),
    ).format(item.createdAt);

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
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
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
            if (orderId != null && orderId.isNotEmpty) {
              final authState = context.read<AuthBloc>().state;
              final isDriverMode = authState.maybeWhen(
                authenticated: (token, userId, currentMode) =>
                    currentMode == 'delivery',
                orElse: () => false,
              );

              if (isDriverMode) {
                // Pour le livreur, on redirige vers le dashboard principal qui recharge
                context.go('/delivery');
              } else {
                if (type == 'new_mission' ||
                    type == 'order_status' ||
                    type == 'delivery') {
                  context.push('/client/tracking/$orderId');
                }
              }
            } else {
              _showPromotionDetailDialog(context, item);
            }
          } else {
            _showPromotionDetailDialog(context, item);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead
                ? Colors.white
                : AppTheme.bgWarm.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead
                  ? AppTheme.lineSoft
                  : AppTheme.primaryRed.withValues(alpha: 0.15),
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
                  color: item.isRead
                      ? AppTheme.bgWarm
                      : AppTheme.primaryRed.withValues(alpha: 0.1),
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
                              fontWeight: item.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
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
                        color: item.isRead
                            ? AppTheme.muted
                            : AppTheme.ink.withValues(alpha: 0.8),
                        fontWeight: item.isRead
                            ? FontWeight.normal
                            : FontWeight.w500,
                      ),
                    ),
                    if (item.data != null &&
                        (item.data!['imageUrl'] != null ||
                            item.data!['image'] != null)) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          (item.data!['imageUrl'] ?? item.data!['image'])
                              .toString(),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 150,
                              color: AppTheme.bgWarm,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryRed,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: AppTheme.bgWarm,
                  ),
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

  void _showPromotionDetailDialog(
    BuildContext context,
    NotificationModel item,
  ) {
    final imageUrl =
        item.data?['imageUrl']?.toString() ??
        item.data?['image']?.toString() ??
        '';
    final linkUrl =
        item.data?['linkUrl']?.toString() ??
        item.data?['link']?.toString() ??
        item.data?['url']?.toString() ??
        '';

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Upper Image Header
                if (imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 180,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          color: AppTheme.bgWarm,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // Title and Body Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat(
                          'dd MMMM yyyy, HH:mm',
                          context.locale.toString(),
                        ).format(item.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.body,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.5,
                          color: AppTheme.ink.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Fermer',
                          style: TextStyle(
                            color: AppTheme.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (linkUrl.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            final uri = Uri.tryParse(linkUrl);
                            if (uri != null && await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Voir l\'offre',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.open_in_new_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

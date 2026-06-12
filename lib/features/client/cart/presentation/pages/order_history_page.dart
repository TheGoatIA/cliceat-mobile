import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cliceat_app/core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../bloc/order_bloc.dart';
import '../../../home/presentation/pages/client_main_tab.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _scrollController = ScrollController();
  late final OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = getIt<OrderBloc>()..add(const LoadOrders());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= maxScroll - 200) {
      if (_orderBloc.hasMore) {
        _orderBloc.add(const LoadMoreOrders());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _orderBloc,
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          title: Text(
            'order.history'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: AppTheme.ink),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showStatusExplanationDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppTheme.ink),
              onPressed: () {
                HapticFeedback.lightImpact();
                _orderBloc.add(const LoadOrders());
              },
            ),
          ],
          backgroundColor: AppTheme.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            state.maybeWhen(
              cancelled: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('order.cancel_success'.tr()),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                _orderBloc.add(const LoadOrders());
              },
              reorderSuccess: (newOrderId, paymentUrl) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('order.reorder_success'.tr()),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                if (paymentUrl != null && paymentUrl.isNotEmpty) {
                  context.push(
                    '/client/payment',
                    extra: {'orderId': newOrderId, 'paymentUrl': paymentUrl},
                  );
                } else {
                  context.push('/client/tracking/$newOrderId');
                }
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message.tr()),
                    backgroundColor: AppTheme.errorColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              invoiceDownloaded: (path) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppTheme.redSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: AppTheme.primaryRed,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Facture téléchargée',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'La facture a été enregistrée en local.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    OpenFilex.open(path);
                                  },
                                  icon: const Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 18,
                                  ),
                                  label: Text('order.view'.tr()),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.ink,
                                    side: BorderSide(color: AppTheme.lineSoft),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    SharePlus.instance.share(
                                      ShareParams(
                                        files: [XFile(path)],
                                        text: 'Facture ClicEat',
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 18,
                                  ),
                                  label: Text('order.share'.tr()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryRed,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => _buildSkeleton(),
                error: (message) => _buildError(context, message),
                ordersLoaded: (orders) =>
                    _buildOrderList(context, orders, isLoadingMore: false),
                loadingMore: (orders) =>
                    _buildOrderList(context, orders, isLoadingMore: true),
                orElse: () => _buildSkeleton(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.bgWarm,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppTheme.muted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.errorColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _orderBloc.add(const LoadOrders()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text('common.retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<Map<String, dynamic>> orders, {
    required bool isLoadingMore,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.bgWarm,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: AppTheme.muted.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'order.no_orders'.tr(),
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'order.no_orders_subtitle'.tr(),
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  final mainTab = context
                      .findAncestorStateOfType<ClientMainTabState>();
                  if (mainTab != null) {
                    mainTab.setIndex(0);
                  } else {
                    context.go('/client');
                  }
                },
                icon: const Icon(Icons.restaurant_rounded),
                label: Text('order.browse_restaurants'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final itemCount = orders.length + (isLoadingMore ? 1 : 0);
    return RefreshIndicator(
      onRefresh: () async {
        _orderBloc.add(const LoadOrders());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppTheme.primaryRed,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == orders.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildOrderCard(context, orders[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '';
    final shortId = orderId.length > 8
        ? orderId.substring(orderId.length - 8)
        : orderId;
    final status = order['status'] as String? ?? 'pending';
    final rawTotal = order['totalAmount'] ?? order['total'];
    final String total;
    if (rawTotal is num) {
      total = rawTotal.toStringAsFixed(0);
    } else if (rawTotal != null) {
      final parsed = double.tryParse(rawTotal.toString());
      total = parsed != null ? parsed.toStringAsFixed(0) : rawTotal.toString();
    } else {
      total = '--';
    }

    final rawRestaurant = order['restaurant'] ?? order['restaurantId'];
    final restaurant = rawRestaurant is Map<String, dynamic>
        ? rawRestaurant
        : null;
    final restaurantName =
        restaurant?['name'] as String? ??
        order['restaurantName'] as String? ??
        '';
    final restaurantLogo =
        restaurant?['logo'] as String? ??
        restaurant?['logoUrl'] as String? ??
        order['restaurantLogo'] as String?;
    final invoiceUrl = order['invoiceUrl']?.toString();
    final isDelivered = status == 'delivered';
    final isCancelled = status == 'cancelled';
    final isScheduled = order['isScheduled'] as bool? ?? false;
    final locale = context.locale.languageCode;
    final createdAt = formatDate(order['createdAt'], locale: locale);

    // Items summary
    final items = order['items'] as List<dynamic>? ?? [];
    final itemsSummary = items.isEmpty
        ? ''
        : items
              .take(3)
              .map((i) {
                final name =
                    (i as Map<String, dynamic>)['name']?.toString() ?? '';
                final qty = i['quantity']?.toString() ?? '1';
                return '$qty× $name';
              })
              .join(', ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (!isCancelled && status != 'delivered') {
            context.push('/client/tracking/$orderId');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: restaurant info + status
              Row(
                children: [
                  // Logo restaurant
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.bgWarm,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: restaurantLogo != null
                        ? Image.network(
                            restaurantLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.restaurant_rounded,
                              color: AppTheme.muted,
                            ),
                          )
                        : const Icon(
                            Icons.restaurant_rounded,
                            color: AppTheme.muted,
                            size: 24,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantName.isNotEmpty
                              ? restaurantName
                              : 'order.unknown_restaurant'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${'order.order_id'.tr()}$shortId',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.muted,
                              ),
                            ),
                            if (createdAt.isNotEmpty) ...[
                              Text(
                                ' · ',
                                style: GoogleFonts.inter(color: AppTheme.muted),
                              ),
                              Text(
                                createdAt,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.muted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isScheduled && status == 'pending')
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 11,
                              color: Color(0xFF7C3AED),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'order.scheduled_badge'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF7C3AED),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  _buildStatusChip(status, theme),
                ],
              ),

              // Items summary
              if (itemsSummary.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  itemsSummary,
                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 12),

              // Footer: montant + actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$total FCFA',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              _showOrderDetailsBottomSheet(context, order),
                          icon: const Icon(
                            Icons.receipt_long_rounded,
                            size: 16,
                            color: AppTheme.ink,
                          ),
                          label: Text(
                            'order.details'.tr(),
                            style: const TextStyle(
                              color: AppTheme.ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        if (status == 'pending' || status == 'pending_payment')
                          TextButton.icon(
                            onPressed: () =>
                                _showCancelDialog(context, orderId),
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 16,
                              color: AppTheme.primaryRed,
                            ),
                            label: Text(
                              'order.cancel'.tr(),
                              style: const TextStyle(
                                color: AppTheme.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                        if (!isCancelled && !isDelivered)
                          TextButton.icon(
                            onPressed: () =>
                                context.push('/client/tracking/$orderId'),
                            icon: const Icon(
                              Icons.location_on_rounded,
                              size: 16,
                            ),
                            label: Text('order.track_order'.tr()),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                        if (isDelivered || isCancelled)
                          TextButton.icon(
                            onPressed: () => _orderBloc.add(
                              OrderEvent.reorderOrder(orderId),
                            ),
                            icon: const Icon(Icons.replay_rounded, size: 16),
                            label: Text('order.reorder'.tr()),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                        if (isDelivered)
                          IconButton(
                            icon: const Icon(
                              Icons.star_outline_rounded,
                              size: 20,
                            ),
                            onPressed: () =>
                                context.push('/client/rate/$orderId'),
                            tooltip: 'order.rate'.tr(),
                            color: AppTheme.honey,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            size: 20,
                          ),
                          onPressed: () =>
                              context.push('/client/dispute/create/$orderId'),
                          tooltip: 'order.report_problem'.tr(),
                          color: AppTheme.muted,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        if (isDelivered || invoiceUrl != null)
                          IconButton(
                            icon: const Icon(Icons.download_rounded, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('order.downloading'.tr()),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              _orderBloc.add(
                                OrderEvent.downloadInvoice(orderId),
                              );
                            },
                            tooltip: 'order.download_invoice'.tr(),
                            color: AppTheme.primaryRed,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, String orderId) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'order.cancel_dialog_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppTheme.ink,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'order.cancel_dialog_message'.tr(),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.inkSoft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: 'order.cancel_reason_hint'.tr(),
                hintStyle: GoogleFonts.inter(
                  color: AppTheme.muted,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.lineSoft),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.lineSoft),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryRed,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: AppTheme.bgWarm,
              ),
              style: GoogleFonts.inter(fontSize: 13),
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'common.cancel'.tr(),
              style: GoogleFonts.inter(color: AppTheme.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'order.cancel_confirm'.tr(),
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final reason = reasonController.text.trim();
      _orderBloc.add(CancelOrder(orderId, reason.isEmpty ? null : reason));
    }
    reasonController.dispose();
  }

  void _showStatusExplanationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            final statuses = [
              (
                'pending_payment',
                'order.status_pending_payment'.tr(),
                'order.explain_pending_payment'.tr(),
                AppTheme.statusPending,
              ),
              (
                'pending',
                'order.status_pending'.tr(),
                'order.explain_pending'.tr(),
                AppTheme.statusPending,
              ),
              (
                'confirmed',
                'order.status_confirmed'.tr(),
                'order.explain_confirmed'.tr(),
                AppTheme.statusConfirmed,
              ),
              (
                'preparing',
                'order.status_preparing'.tr(),
                'order.explain_preparing'.tr(),
                AppTheme.statusPreparing,
              ),
              (
                'ready',
                'order.status_ready'.tr(),
                'order.explain_ready'.tr(),
                AppTheme.statusReady,
              ),
              (
                'en_route',
                'order.status_en_route'.tr(),
                'order.explain_en_route'.tr(),
                AppTheme.statusEnRoute,
              ),
              (
                'delivered',
                'order.status_delivered'.tr(),
                'order.explain_delivered'.tr(),
                AppTheme.statusDelivered,
              ),
              (
                'cancelled',
                'order.status_cancelled'.tr(),
                'order.explain_cancelled'.tr(),
                AppTheme.statusCancelled,
              ),
              (
                'anomaly',
                'order.status_anomaly'.tr(),
                'order.explain_anomaly'.tr(),
                AppTheme.statusAnomaly,
              ),
            ];

            return SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'order.status_explanation_title'.tr(),
                          style: GoogleFonts.bricolageGrotesque(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppTheme.ink,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: statuses.length,
                      separatorBuilder: (_, _) =>
                          const Divider(color: AppTheme.lineSoft, height: 24),
                      itemBuilder: (context, index) {
                        final (_, label, explanation, color) = statuses[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                explanation,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.inkSoft,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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

  void _showOrderDetailsBottomSheet(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    final rawRestaurant = order['restaurant'] ?? order['restaurantId'];
    final restaurant = rawRestaurant is Map<String, dynamic>
        ? rawRestaurant
        : null;
    final restaurantName =
        restaurant?['name'] as String? ??
        order['restaurantName'] as String? ??
        'order.unknown_restaurant'.tr();
    final restaurantLogo =
        restaurant?['logo'] as String? ??
        restaurant?['logoUrl'] as String? ??
        order['restaurantLogo'] as String?;
    final orderId = order['_id']?.toString() ?? '';
    final shortId = orderId.length >= 8
        ? orderId.substring(0, 8).toUpperCase()
        : orderId.toUpperCase();
    final locale = context.locale.languageCode;
    final createdAt = formatDate(order['createdAt'], locale: locale);
    final status = order['status'] as String? ?? 'pending';

    // Items
    final items = order['items'] as List<dynamic>? ?? [];

    // Totals
    final total = (order['total'] as num?)?.toDouble() ?? 0.0;
    final deliveryFee = (order['deliveryFee'] as num?)?.toDouble() ?? 2000.0;
    // Calculate subtotal
    double subtotal = 0.0;
    for (final item in items) {
      final qty = (item['quantity'] as num?)?.toInt() ?? 1;
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      subtotal += qty * price;
    }
    // Calculate discount if total and delivery fee don't sum up to subtotal
    final discount = (subtotal + deliveryFee) - total;
    final finalDiscount = discount > 0 ? discount : 0.0;

    // Delivery address & notes
    final addrRaw = order['deliveryAddress'] as Map<String, dynamic>?;
    final addressText = addrRaw?['address']?.toString() ?? '';
    final addressLabel = addrRaw?['label']?.toString() ?? 'Adresse';
    final notesText =
        order['notes']?.toString() ?? order['deliveryNotes']?.toString() ?? '';

    // Payment method
    final paymentMethod = order['paymentMethod']?.toString() ?? '';
    final paymentMethodLabel = switch (paymentMethod) {
      'orange_money' => 'Orange Money',
      'mtn_momo' => 'MTN MoMo',
      'wallet' => 'Portefeuille',
      'cash' => 'Espèces',
      _ => paymentMethod.toUpperCase(),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  // Pull handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'order.details'.tr(),
                          style: GoogleFonts.bricolageGrotesque(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: AppTheme.ink,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Restaurant overview card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.bgWarm,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.lineSoft),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  border: Border.all(color: AppTheme.lineSoft),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child:
                                    restaurantLogo != null &&
                                        restaurantLogo.isNotEmpty
                                    ? Image.network(
                                        restaurantLogo,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.restaurant_rounded,
                                          color: AppTheme.muted,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.restaurant_rounded,
                                        color: AppTheme.muted,
                                        size: 28,
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurantName,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppTheme.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${'order.order_id'.tr()}$shortId · $createdAt',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppTheme.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildStatusChip(status, theme),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Items list header
                        Text(
                          'Plats commandés',
                          style: GoogleFonts.bricolageGrotesque(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppTheme.ink,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Items items
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = items[index] as Map<String, dynamic>;
                            final name = item['name']?.toString() ?? '';
                            final qty =
                                (item['quantity'] as num?)?.toInt() ?? 1;
                            final price =
                                (item['price'] as num?)?.toDouble() ?? 0.0;
                            final variation = item['variation']?.toString();

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.redSoft,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${qty}x',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: AppTheme.primaryRed,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppTheme.ink,
                                        ),
                                      ),
                                      if (variation != null &&
                                          variation.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          variation,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Text(
                                  '${(qty * price).toStringAsFixed(0)} FCFA',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppTheme.ink,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.lineSoft, height: 24),

                        // Payment summary (Receipt breakdown)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sous-total',
                              style: GoogleFonts.inter(
                                color: AppTheme.muted,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${subtotal.toStringAsFixed(0)} FCFA',
                              style: GoogleFonts.inter(
                                color: AppTheme.ink,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Frais de livraison',
                              style: GoogleFonts.inter(
                                color: AppTheme.muted,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${deliveryFee.toStringAsFixed(0)} FCFA',
                              style: GoogleFonts.inter(
                                color: AppTheme.ink,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (finalDiscount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Réduction',
                                style: GoogleFonts.inter(
                                  color: AppTheme.successColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '-${finalDiscount.toStringAsFixed(0)} FCFA',
                                style: GoogleFonts.inter(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.bricolageGrotesque(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: AppTheme.ink,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(0)} FCFA',
                              style: GoogleFonts.bricolageGrotesque(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                          ],
                        ),

                        const Divider(color: AppTheme.lineSoft, height: 32),

                        // Delivery Address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: AppTheme.muted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Adresse de livraison',
                              style: GoogleFonts.bricolageGrotesque(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppTheme.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (addressLabel.isNotEmpty) ...[
                                Text(
                                  addressLabel,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppTheme.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                addressText.isNotEmpty
                                    ? addressText
                                    : 'Aucune adresse renseignée',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.muted,
                                  height: 1.3,
                                ),
                              ),
                              if (notesText.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.bgWarm,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.lineSoft,
                                    ),
                                  ),
                                  child: Text(
                                    '" $notesText "',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppTheme.muted,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const Divider(color: AppTheme.lineSoft, height: 32),

                        // Payment Method
                        Row(
                          children: [
                            const Icon(
                              Icons.payment_rounded,
                              size: 20,
                              color: AppTheme.muted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mode de paiement',
                              style: GoogleFonts.bricolageGrotesque(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppTheme.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.bgWarm,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.lineSoft),
                              ),
                              child: Text(
                                paymentMethodLabel,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppTheme.ink,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
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

  Widget _buildStatusChip(String status, ThemeData theme) {
    final (label, color) = switch (status) {
      'pending' => ('order.status_pending'.tr(), AppTheme.statusPending),
      'confirmed' => ('order.status_confirmed'.tr(), AppTheme.statusConfirmed),
      'preparing' => ('order.status_preparing'.tr(), AppTheme.statusPreparing),
      'ready' => ('order.status_ready'.tr(), AppTheme.statusReady),
      'picked_up' => ('order.status_picked_up'.tr(), AppTheme.statusPickedUp),
      'delivered' => ('order.status_delivered'.tr(), AppTheme.statusDelivered),
      'cancelled' => ('order.status_cancelled'.tr(), AppTheme.statusCancelled),
      'anomaly' => ('order.status_anomaly'.tr(), AppTheme.statusAnomaly),
      'en_route' => ('order.status_en_route'.tr(), AppTheme.statusEnRoute),
      'pending_payment' => (
        'order.status_pending_payment'.tr(),
        AppTheme.statusPending,
      ),
      _ => (status, AppTheme.statusDefault),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

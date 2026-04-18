import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cliceat_app/core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../bloc/order_bloc.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= maxScroll - 200) {
      final bloc = context.read<OrderBloc>();
      if (bloc.hasMore) {
        bloc.add(const OrderEvent.loadMoreOrders());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<OrderBloc>()..add(const OrderEvent.loadOrders()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'order.history'.tr(),
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            state.maybeWhen(
              reorderSuccess: (newOrderId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('order.reorder_success'.tr()),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
                context.push('/client/tracking/$newOrderId');
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message.tr()),
                    backgroundColor:
                        Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              invoiceDownloaded: (path) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('order.invoice_downloaded'.tr()),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
                // ignore: deprecated_member_use
                Share.shareXFiles(
                    [XFile(path)], text: 'Facture ClicEat');
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => _buildSkeleton(),
                error: (message) =>
                    _buildError(context, message),
                ordersLoaded: (orders) =>
                    _buildOrderList(context, orders,
                        isLoadingMore: false),
                loadingMore: (orders) =>
                    _buildOrderList(context, orders,
                        isLoadingMore: true),
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
          color: Colors.grey.shade200,
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
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              message.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<OrderBloc>()
                  .add(const OrderEvent.loadOrders()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text('common.retry'.tr()),
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
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'order.no_orders'.tr(),
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'order.no_orders_subtitle'.tr(),
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/client'),
                icon: const Icon(Icons.restaurant_rounded),
                label: Text('order.browse_restaurants'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    final itemCount = orders.length + (isLoadingMore ? 1 : 0);
    return ListView.separated(
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
    );
  }

  Widget _buildOrderCard(
      BuildContext context, Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final orderId = order['_id']?.toString() ??
        order['id']?.toString() ??
        '';
    final shortId = orderId.length > 8
        ? orderId.substring(orderId.length - 8)
        : orderId;
    final status = order['status'] as String? ?? 'pending';
    final total = order['totalAmount']?.toString() ??
        order['total']?.toString() ??
        '--';
    final restaurant =
        order['restaurant'] as Map<String, dynamic>?;
    final restaurantName =
        restaurant?['name'] as String? ?? '';
    final restaurantLogo =
        restaurant?['logo'] as String? ??
            restaurant?['logoUrl'] as String?;
    final invoiceUrl = order['invoiceUrl']?.toString();
    final isDelivered = status == 'delivered';
    final isCancelled = status == 'cancelled';
    final locale = context.locale.languageCode;
    final createdAt =
        formatDate(order['createdAt'], locale: locale);

    // Items summary
    final items = order['items'] as List<dynamic>? ?? [];
    final itemsSummary = items.isEmpty
        ? ''
        : items
            .take(3)
            .map((i) {
              final name =
                  (i as Map<String, dynamic>)['name']
                      ?.toString() ??
                  '';
              final qty = i['quantity']?.toString() ?? '1';
              return '$qty× $name';
            })
            .join(', ');

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                      color: theme.colorScheme
                          .surfaceContainerHighest,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: restaurantLogo != null
                        ? Image.network(
                            restaurantLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.restaurant_rounded,
                              color: theme.colorScheme
                                  .onSurfaceVariant,
                            ),
                          )
                        : Icon(
                            Icons.restaurant_rounded,
                            color: theme.colorScheme
                                .onSurfaceVariant,
                            size: 24,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                        Row(
                          children: [
                            Text(
                              '${'order.order_id'.tr()}$shortId',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            if (createdAt.isNotEmpty) ...[
                              Text(
                                ' · ',
                                style: TextStyle(
                                    color: theme.colorScheme
                                        .onSurfaceVariant),
                              ),
                              Text(
                                createdAt,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
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
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 12),

              // Footer: montant + actions
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$total FCFA',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isCancelled && !isDelivered)
                        TextButton.icon(
                          onPressed: () => context.push(
                              '/client/tracking/$orderId'),
                          icon: const Icon(
                              Icons.location_on_rounded,
                              size: 16),
                          label: Text('order.track_order'.tr()),
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 8),
                          ),
                        ),
                      if (isDelivered || isCancelled)
                        TextButton.icon(
                          onPressed: () => context
                              .read<OrderBloc>()
                              .add(OrderEvent.reorderOrder(
                                  orderId)),
                          icon: const Icon(
                              Icons.replay_rounded,
                              size: 16),
                          label: Text('order.reorder'.tr()),
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 8),
                          ),
                        ),
                      if (isDelivered)
                        IconButton(
                          icon: const Icon(
                              Icons.star_outline_rounded,
                              size: 20),
                          onPressed: () => context.push(
                              '/client/rate/$orderId'),
                          tooltip: 'order.rate'.tr(),
                          color: Colors.amber,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4),
                        ),
                      IconButton(
                        icon: const Icon(Icons.help_outline_rounded, size: 20),
                        onPressed: () => context.push('/client/dispute/create/$orderId'),
                        tooltip: 'order.report_problem'.tr(),
                        color: theme.colorScheme.onSurfaceVariant,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      if (isDelivered || invoiceUrl != null)
                        IconButton(
                          icon: const Icon(
                              Icons.download_rounded,
                              size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                  'order.downloading'.tr()),
                              duration:
                                  const Duration(seconds: 1),
                            ));
                            context.read<OrderBloc>().add(
                                OrderEvent.downloadInvoice(
                                    orderId));
                          },
                          tooltip:
                              'order.download_invoice'.tr(),
                          color: theme.colorScheme.primary,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:cliceat_app/core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/date_formatter.dart';
import 'package:share_plus/share_plus.dart';
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
    // Charger la page suivante quand on approche du bas (200 px avant la fin)
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
        appBar: AppBar(
          title: Text('order.history'.tr()),
          elevation: 0,
        ),
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            state.maybeWhen(
              reorderSuccess: (newOrderId) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('order.reorder_success'.tr()),
                ));
                context.push('/client/tracking/$newOrderId');
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message.tr()),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              },
              invoiceDownloaded: (path) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Facture téléchargée avec succès !'),
                  duration: Duration(seconds: 2),
                ));
                // ignore: deprecated_member_use
                Share.shareXFiles([XFile(path)], text: 'Facture ClicEat');
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (message) => _buildError(context, message),
              ordersLoaded: (orders) =>
                  _buildOrderList(context, orders, isLoadingMore: false),
              loadingMore: (orders) =>
                  _buildOrderList(context, orders, isLoadingMore: true),
              orElse: () =>
                  const Center(child: CircularProgressIndicator()),
            );
          },
        ),
          ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message.tr(),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context
                .read<OrderBloc>()
                .add(const OrderEvent.loadOrders()),
            child: Text('common.retry'.tr()),
          ),
        ],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 80,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text('order.no_orders'.tr(),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('order.no_orders_subtitle'.tr(),
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant)),
          ],
        ),
      );
    }

    // Ajouter un item fictif à la fin pour le loader si nécessaire
    final itemCount = orders.length + (isLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == orders.length) {
          // Indicateur de chargement en bas de liste
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
    final orderId =
        order['_id']?.toString() ?? order['id']?.toString() ?? '';
    final shortId = orderId.length > 8
        ? orderId.substring(orderId.length - 8)
        : orderId;
    final status = order['status'] as String? ?? 'pending';
    final total = order['totalAmount']?.toString() ??
        order['total']?.toString() ??
        '--';
    final restaurantName =
        (order['restaurant'] as Map<String, dynamic>?)?['name']
                as String? ??
            '';
    final invoiceUrl = order['invoiceUrl']?.toString();
    final isDelivered = status == 'delivered';
    final isCancelled = status == 'cancelled';
    final locale = context.locale.languageCode;
    final createdAt = formatDate(order['createdAt'], locale: locale);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'order.order_id'.tr()}$shortId',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(status, theme),
              ],
            ),
            if (restaurantName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(restaurantName,
                  style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant)),
            ],
            if (createdAt.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(createdAt,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$total FCFA',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    if (isDelivered || isCancelled)
                      TextButton.icon(
                        onPressed: () => context
                            .read<OrderBloc>()
                            .add(OrderEvent.reorderOrder(orderId)),
                        icon: const Icon(Icons.replay, size: 16),
                        label: Text('order.reorder'.tr()),
                      ),
                    if (isDelivered)
                      TextButton(
                        onPressed: () =>
                            _showRateDialog(context, orderId),
                        child: Text('order.rate'.tr()),
                      ),
                    if (!isCancelled && status != 'delivered')
                      TextButton(
                        onPressed: () =>
                            context.push('/client/tracking/$orderId'),
                        child: Text('order.track_order'.tr()),
                      ),
                    if (isDelivered || invoiceUrl != null)
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Téléchargement en cours...')));
                          context.read<OrderBloc>().add(OrderEvent.downloadInvoice(orderId));
                        },
                        icon: const Icon(Icons.download_rounded),
                        tooltip: 'Télécharger la facture',
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    final (label, color) = switch (status) {
      'pending'   => ('order.status_pending'.tr(),   AppTheme.statusPending),
      'confirmed' => ('order.status_confirmed'.tr(), AppTheme.statusConfirmed),
      'preparing' => ('order.status_preparing'.tr(), AppTheme.statusPreparing),
      'ready'     => ('order.status_ready'.tr(),     AppTheme.statusReady),
      'picked_up' => ('order.status_picked_up'.tr(), AppTheme.statusPickedUp),
      'delivered' => ('order.status_delivered'.tr(), AppTheme.statusDelivered),
      'cancelled' => ('order.status_cancelled'.tr(), AppTheme.statusCancelled),
      _           => (status,                        AppTheme.statusDefault),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }

  void _showRateDialog(BuildContext context, String orderId) {
    int rating = 5;
    final commentCtrl = TextEditingController();
    final bloc = context.read<OrderBloc>();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('order.rate_title'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    5,
                    (i) => IconButton(
                          icon: Icon(
                            i < rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () =>
                              setDialogState(() => rating = i + 1),
                        )),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentCtrl,
                decoration: InputDecoration(
                  hintText: 'order.rate_comment_hint'.tr(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('common.cancel'.tr())),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                bloc.add(OrderEvent.rateOrder(
                  orderId: orderId,
                  rating: rating,
                  comment: commentCtrl.text.trim().isNotEmpty
                      ? commentCtrl.text.trim()
                      : null,
                ));
              },
              child: Text('order.submit_rating'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

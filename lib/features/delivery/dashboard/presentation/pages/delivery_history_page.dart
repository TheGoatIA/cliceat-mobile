import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasources/mission_service.dart';

class DeliveryHistoryPage extends StatefulWidget {
  const DeliveryHistoryPage({super.key});

  @override
  State<DeliveryHistoryPage> createState() => _DeliveryHistoryPageState();
}

class _DeliveryHistoryPageState extends State<DeliveryHistoryPage> {
  List<Map<String, dynamic>> _missions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final res = await getIt<MissionService>().getMyOrders();
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        List<dynamic> data = [];
        if (body is Map && body.containsKey('data')) {
          data = body['data'] as List<dynamic>? ?? [];
        } else if (body is List) {
          data = body;
        }
        setState(() {
          _missions = data.cast<Map<String, dynamic>>();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.history_title'.tr()),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => _loading = true);
                await _loadHistory();
              },
              child: _missions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'delivery.no_history'.tr(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _missions.length,
                      itemBuilder: (context, index) {
                        final mission = _missions[index];
                        return _buildMissionCard(context, theme, mission);
                      },
                    ),
            ),
    );
  }

  Widget _buildMissionCard(BuildContext context, ThemeData theme, Map<String, dynamic> mission) {
    final id = mission['_id']?.toString() ?? mission['id']?.toString() ?? '';
    final status = mission['status']?.toString() ?? 'unknown';
    final amount = (mission['totalAmount'] as num?)?.toStringAsFixed(0) ?? '0';
    final restaurant = (mission['restaurant'] as Map<String, dynamic>?)?['name']?.toString() ?? 'Restaurant';
    final createdAt = mission['createdAt']?.toString() ?? '';
    final deliveryFee = (mission['deliveryFee'] as num?)?.toStringAsFixed(0) ?? '0';

    String formattedDate = createdAt;
    try {
      final dt = DateTime.parse(createdAt);
      formattedDate = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {}

    final statusColor = _statusColor(theme, status);
    final statusLabel = _statusLabel(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    restaurant,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(formattedDate, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(width: 16),
                Icon(Icons.receipt, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${'delivery.order_amount'.tr()}: $amount FCFA',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
            if (deliveryFee != '0') ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.delivery_dining, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${'delivery.your_earnings'.tr()}: $deliveryFee FCFA',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(ThemeData theme, String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return theme.colorScheme.error;
      case 'pending':
        return Colors.orange;
      case 'picked_up':
      case 'in_transit':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurfaceVariant;
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

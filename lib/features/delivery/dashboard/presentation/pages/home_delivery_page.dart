import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/network/services/delivery_service.dart';

class HomeDeliveryPage extends StatefulWidget {
  const HomeDeliveryPage({super.key});

  @override
  State<HomeDeliveryPage> createState() => _HomeDeliveryPageState();
}

class _HomeDeliveryPageState extends State<HomeDeliveryPage> {
  late final DeliveryService _service;
  bool _isOnline = false;
  bool _togglingStatus = false;
  Map<String, dynamic>? _earnings;
  List<dynamic> _recentOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = GetIt.instance<DeliveryService>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _service.getDriverEarnings(),
        _service.getDriverOrders(),
      ]);
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (results[0].isSuccessful) {
          _earnings =
              (results[0].body as Map<String, dynamic>?)?['data']
                  as Map<String, dynamic>?;
        }
        if (results[1].isSuccessful) {
          final d = results[1].body as Map<String, dynamic>?;
          _recentOrders = (d?['data'] as List?)?.take(5).toList() ?? [];
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleOnline(bool value) async {
    setState(() => _togglingStatus = true);
    try {
      final res =
          await _service.updateDriverStatus({'isOnline': value});
      if (res.isSuccessful && mounted) {
        setState(() => _isOnline = value);
      } else if (mounted) {
        _showError('Impossible de changer le statut.');
      }
    } catch (_) {
      if (mounted) _showError('Erreur réseau.');
    } finally {
      if (mounted) setState(() => _togglingStatus = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.dashboard_title'.tr()),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusToggle(theme),
              const SizedBox(height: 20),
              _buildStatusCard(theme),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildStats(theme),
              const SizedBox(height: 20),
              _buildRecentDeliveries(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mon statut',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isOnline
                        ? 'delivery.online'.tr()
                        : 'delivery.offline'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: _isOnline ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _togglingStatus
              ? const SizedBox(
                  width: 40,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Switch(
                  value: _isOnline,
                  activeColor: theme.colorScheme.primary,
                  onChanged: _toggleOnline,
                ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 140,
      decoration: BoxDecoration(
        gradient: _isOnline
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey.shade200, Colors.grey.shade100],
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isOnline
                  ? Icons.radar_rounded
                  : Icons.power_settings_new_rounded,
              size: 44,
              color: _isOnline ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              _isOnline
                  ? 'delivery.waiting_mission'.tr()
                  : 'Vous êtes hors ligne',
              style: theme.textTheme.titleLarge?.copyWith(
                color: _isOnline ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isOnline) ...
              [
                const SizedBox(height: 4),
                Text(
                  'En attente de commandes...',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13),
                ),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildStats(ThemeData theme) {
    final todayEarnings =
        _earnings?['today']?.toString() ?? '0';
    final totalDeliveries =
        _earnings?['totalDeliveries']?.toString() ?? '0';

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'delivery.todays_earnings'.tr(),
            value: '$todayEarnings FCFA',
            icon: Icons.account_balance_wallet_rounded,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            title: 'delivery.deliveries'.tr(),
            value: totalDeliveries,
            icon: Icons.delivery_dining_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentDeliveries(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dernières livraisons',
            style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        if (_recentOrders.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Aucune livraison récente.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5)),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentOrders.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final o = _recentOrders[i] as Map<String, dynamic>;
              final id =
                  (o['shortId'] as String?) ?? o['_id'].toString();
              final amount =
                  ((o['deliveryFee'] as num?)?.toInt() ?? 0)
                      .toString();
              final status = (o['status'] as String?) ?? 'delivered';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: Colors.green),
                ),
                title: Text('Commande #$id'),
                subtitle: Text(status),
                trailing: Text(
                  '+$amount FCFA',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

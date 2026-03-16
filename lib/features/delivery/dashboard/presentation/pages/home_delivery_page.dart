import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeDeliveryPage extends StatefulWidget {
  const HomeDeliveryPage({super.key});

  @override
  State<HomeDeliveryPage> createState() => _HomeDeliveryPageState();
}

class _HomeDeliveryPageState extends State<HomeDeliveryPage> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.dashboard_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOnlineToggle(theme),
            const SizedBox(height: 24),
            _buildStatusCard(theme),
            const SizedBox(height: 24),
            _buildTodayStats(theme),
            const SizedBox(height: 24),
            _buildRecentDeliveries(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'delivery.status'.tr(),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isOnline ? 'delivery.online'.tr() : 'delivery.offline'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isOnline ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: isOnline,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
            activeColor: theme.colorScheme.primary,
            onChanged: (value) {
              setState(() {
                isOnline = value;
                // TODO: Dispatch event to bloc to trigger GPS Background Service
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    // Current Mission OR Waiting State
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: isOnline ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline ? theme.colorScheme.primary.withValues(alpha: 0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOnline ? Icons.radar : Icons.power_settings_new,
              size: 48,
              color: isOnline ? theme.colorScheme.primary : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isOnline ? 'delivery.waiting_mission'.tr() : 'delivery.you_are_offline'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                color: isOnline ? theme.colorScheme.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'delivery.todays_earnings'.tr(),
            value: '12 500 FCFA',
            icon: Icons.account_balance_wallet,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'delivery.deliveries'.tr(),
            value: '8 coursiers',
            icon: Icons.delivery_dining,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecentDeliveries(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.recent_deliveries'.tr(),
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              title: const Text('Commande #10842'),
              subtitle: const Text('Livré à 14:30 • Akwa'),
              trailing: Text(
                '+1500 FCFA',
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

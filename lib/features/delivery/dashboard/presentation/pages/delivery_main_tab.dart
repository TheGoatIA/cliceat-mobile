import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_delivery_page.dart';

class DeliveryMainTab extends StatefulWidget {
  const DeliveryMainTab({super.key});

  @override
  State<DeliveryMainTab> createState() => _DeliveryMainTabState();
}

class _DeliveryMainTabState extends State<DeliveryMainTab> {
  int _index = 0;

  final List<Widget> _pages = [
    const HomeDeliveryPage(),
    const _PlaceholderPage(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Gains',
      subtitle: 'Consultez vos revenus et historique de paiements',
    ),
    const _PlaceholderPage(
      icon: Icons.history_rounded,
      title: 'Historique',
      subtitle: 'Toutes vos livraisons effectuées',
    ),
    const _PlaceholderPage(
      icon: Icons.person_rounded,
      title: 'Profil',
      subtitle: 'Gérez votre profil livreur',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: 'delivery.dashboard_title'.tr(),
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon:
                Icon(Icons.account_balance_wallet_rounded),
            label: 'Gains',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Historique',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _PlaceholderPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

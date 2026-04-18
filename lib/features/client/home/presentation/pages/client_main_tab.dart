import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_client_page.dart';

class ClientMainTab extends StatefulWidget {
  const ClientMainTab({super.key});

  @override
  State<ClientMainTab> createState() => _ClientMainTabState();
}

class _ClientMainTabState extends State<ClientMainTab> {
  int _index = 0;

  final List<Widget> _pages = [
    const HomeClientPage(),
    const _ComingSoonPage(
      icon: Icons.map_rounded,
      title: 'Carte',
      subtitle: 'Trouvez les restaurants près de vous',
    ),
    const _ComingSoonPage(
      icon: Icons.shopping_cart_rounded,
      title: 'Panier',
      subtitle: 'Votre panier est vide',
    ),
    const _ComingSoonPage(
      icon: Icons.person_rounded,
      title: 'Profil',
      subtitle: 'Gérez votre compte',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: 'client.home_title'.tr(),
          ),
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Carte',
          ),
          const NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Panier',
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

class _ComingSoonPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ComingSoonPage({
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
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_delivery_page.dart';

class DeliveryMainTab extends StatefulWidget {
  const DeliveryMainTab({super.key});

  @override
  State<DeliveryMainTab> createState() => _DeliveryMainTabState();
}

class _DeliveryMainTabState extends State<DeliveryMainTab> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeDeliveryPage(),
    const Center(child: Text('Earnings')),
    const Center(child: Text('History')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: 'delivery.dashboard_title'.tr(),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Gains',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Historique',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

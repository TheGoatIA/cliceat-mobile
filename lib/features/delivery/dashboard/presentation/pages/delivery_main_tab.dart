import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_delivery_page.dart';
import 'earnings_page.dart';
import 'delivery_history_page.dart';
import 'delivery_profile_page.dart';

class DeliveryMainTab extends StatefulWidget {
  const DeliveryMainTab({super.key});

  @override
  State<DeliveryMainTab> createState() => _DeliveryMainTabState();
}

class _DeliveryMainTabState extends State<DeliveryMainTab> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomeDeliveryPage(),
    const EarningsPage(),
    const DeliveryHistoryPage(),
    const DeliveryProfilePage(),
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
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: 'delivery.earnings'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_outlined),
            activeIcon: const Icon(Icons.history),
            label: 'delivery.history'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'common.profile'.tr(),
          ),
        ],
      ),
    );
  }
}

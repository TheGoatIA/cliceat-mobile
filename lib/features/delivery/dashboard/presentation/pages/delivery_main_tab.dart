import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_delivery_page.dart';
<<<<<<< HEAD
import 'earnings_page.dart';
import 'delivery_history_page.dart';
import 'delivery_profile_page.dart';
=======
import 'map_delivery_page.dart';
import 'earnings_page.dart';
import '../../../profile/presentation/pages/delivery_profile_page.dart';
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

class DeliveryMainTab extends StatefulWidget {
  const DeliveryMainTab({super.key});

  @override
  State<DeliveryMainTab> createState() => _DeliveryMainTabState();
}

class _DeliveryMainTabState extends State<DeliveryMainTab> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomeDeliveryPage(),
<<<<<<< HEAD
    const EarningsPage(),
    const DeliveryHistoryPage(),
=======
    const MapDeliveryPage(),
    const EarningsPage(),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
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
<<<<<<< HEAD
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: 'delivery.earnings'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_outlined),
            activeIcon: const Icon(Icons.history),
            label: 'delivery.history'.tr(),
=======
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: 'delivery.nav_map'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: 'delivery.nav_earnings'.tr(),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
<<<<<<< HEAD
            label: 'common.profile'.tr(),
=======
            label: 'delivery.nav_profile'.tr(),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
          ),
        ],
      ),
    );
  }
}

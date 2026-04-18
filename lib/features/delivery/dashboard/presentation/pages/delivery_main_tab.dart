import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/socket_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import 'home_delivery_page.dart';
import '../../../../chat/presentation/pages/conversations_page.dart';
import '../../../../client/profile/presentation/pages/profile_page.dart';

class DeliveryMainTab extends StatefulWidget {
  const DeliveryMainTab({super.key});

  @override
  State<DeliveryMainTab> createState() => _DeliveryMainTabState();
}

class _DeliveryMainTabState extends State<DeliveryMainTab> {
  int _currentIndex = 0;

  static const _pages = [
    HomeDeliveryPage(),
    ConversationsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    getIt<SocketService>().connect();
  }

  @override
  void dispose() {
    getIt<SocketService>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) =>
            setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.delivery_dining_outlined),
            selectedIcon: const Icon(Icons.delivery_dining),
            label: 'nav.dashboard'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: 'nav.chat'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: 'nav.profile'.tr(),
          ),
        ],
      ),
    );
  }
}

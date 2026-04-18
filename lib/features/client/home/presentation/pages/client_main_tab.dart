import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../../../../core/di/injection.dart';
import '../../../../../../../core/network/socket_service.dart';
import '../../../../../../../core/services/connectivity_service.dart';
import 'home_client_page.dart';
import '../../../../../chat/presentation/pages/conversations_page.dart';
import '../../../../../client/profile/presentation/pages/profile_page.dart';

class ClientMainTab extends StatefulWidget {
  const ClientMainTab({super.key});

  @override
  State<ClientMainTab> createState() => _ClientMainTabState();
}

class _ClientMainTabState extends State<ClientMainTab> {
  int _currentIndex = 0;

  static const _pages = [
    HomeClientPage(),
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
    return BlocProvider(
      create: (_) => CartBloc(),
      child: Scaffold(
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
        floatingActionButton: BlocBuilder<CartBloc, CartState>(
          builder: (context, cart) {
            if (cart.itemCount == 0) return const SizedBox.shrink();
            return FloatingActionButton.extended(
              onPressed: () => context.push('/cart'),
              icon: Badge(
                label: Text('${cart.itemCount}'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: Text(
                '${cart.total.toStringAsFixed(0)} XAF',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) =>
              setState(() => _currentIndex = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: 'nav.home'.tr(),
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
      ),
    );
  }
}

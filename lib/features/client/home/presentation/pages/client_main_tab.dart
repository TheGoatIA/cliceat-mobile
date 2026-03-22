import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'home_client_page.dart';
import 'map_client_page.dart';

class ClientMainTab extends StatefulWidget {
  const ClientMainTab({super.key});

  @override
  State<ClientMainTab> createState() => _ClientMainTabState();
}

class _ClientMainTabState extends State<ClientMainTab> {
  int _currentIndex = 0;

  // IndexedStack maintient l'état de chaque page entre les navigations.
  static const _pages = [
    HomeClientPage(),
    MapClientPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack préserve l'état des pages (scroll, data) lors du
      // changement d'onglet, contrairement à un simple _pages[_currentIndex].
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'client.nav_home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: 'client.nav_map'.tr(),
          ),
          // BlocSelector : ne reconstruit QUE le badge quand itemCount change.
          // Évite de reconstruire tout le Scaffold à chaque ajout/retrait.
          BottomNavigationBarItem(
            icon: BlocSelector<CartCubit, CartState, int>(
              selector: (state) => state.itemCount,
              builder: (context, count) => _CartIcon(
                count: count,
                active: false,
              ),
            ),
            activeIcon: BlocSelector<CartCubit, CartState, int>(
              selector: (state) => state.itemCount,
              builder: (context, count) => _CartIcon(
                count: count,
                active: true,
              ),
            ),
            label: 'client.nav_cart'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'client.nav_profile'.tr(),
          ),
        ],
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, required this.active});

  final int count;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final icon = active
        ? const Icon(Icons.shopping_cart)
        : const Icon(Icons.shopping_cart_outlined);

    if (count <= 0) return icon;

    return Badge(
      label: Text('$count'),
      child: icon,
    );
  }
}

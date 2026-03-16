import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_client_page.dart';

class ClientMainTab extends StatefulWidget {
  const ClientMainTab({super.key});

  @override
  State<ClientMainTab> createState() => _ClientMainTabState();
}

class _ClientMainTabState extends State<ClientMainTab> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeClientPage(),
    const Center(child: Text('Map')),
    const Center(child: Text('Cart')),
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
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'client.home_title'.tr(),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Carte',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Panier',
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

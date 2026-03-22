import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class DeliveryProfilePage extends StatelessWidget {
  const DeliveryProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.nav_profile'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<AuthBloc>().add(const AuthEvent.logout());
            },
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.two_wheeler, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Livreur ClicEat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  const Text('4.8 (124 notes)'),
                ],
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle(context, 'Paramètres du compte'),
              _buildListTile(context, icon: Icons.person_outline, title: 'Informations personnelles', onTap: () {}),
              _buildListTile(context, icon: Icons.map_outlined, title: 'Zones de livraison préférées', onTap: () {}),
              _buildListTile(context, icon: Icons.airport_shuttle_outlined, title: 'Mon Véhicule (Moto)', onTap: () {}),

              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Configuration App'),
              _buildSwitchTile(context, icon: Icons.notifications_active_outlined, title: 'Sons de mission (Fort)', value: true, onChanged: (v) {}),
              _buildSwitchTile(context, icon: Icons.directions_outlined, title: 'Navigation Auto-start', value: true, onChanged: (v) {}),
              
              const SizedBox(height: 32),

              OutlinedButton.icon(
                icon: const Icon(Icons.swap_horiz),
                label: Text('delivery.switch_client_mode'.tr()),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  context.read<AuthBloc>().add(const AuthEvent.switchMode(mode: 'client'));
                  context.go('/client');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, {required IconData icon, required String title, required bool value, required Function(bool) onChanged}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

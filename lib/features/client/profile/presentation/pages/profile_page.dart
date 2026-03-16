import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('client.nav_profile'.tr()),
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
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Client ClicEat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle(context, 'Mon Compte'),
              _buildListTile(
                context, 
                icon: Icons.history, 
                title: 'Historique des commandes', 
                onTap: () => context.push('/order-history'),
              ),
              _buildListTile(
                context, 
                icon: Icons.location_on_outlined, 
                title: 'Carnet d\'adresses', 
                onTap: () => context.push('/address-selection'),
              ),
              _buildListTile(
                context, 
                icon: Icons.account_balance_wallet_outlined, 
                title: 'Mon Portefeuille', 
                subtitle: '0 FCFA',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Préférences'),
              _buildListTile(
                context, 
                icon: Icons.language, 
                title: 'Changer de langue', 
                onTap: () {},
              ),
              const SizedBox(height: 32),

              OutlinedButton.icon(
                icon: const Icon(Icons.delivery_dining),
                label: const Text('Passer en mode Livreur'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  context.read<AuthBloc>().add(const AuthEvent.switchMode(mode: 'delivery'));
                  context.go('/delivery');
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

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
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
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
      ),
    );
  }
}

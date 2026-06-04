import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class DeliveryProfilePage extends StatelessWidget {
  const DeliveryProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'delivery.nav_profile'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<AuthBloc>().add(const AuthEvent.logout());
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.redSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout,
                color: AppTheme.primaryRed,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.redSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  size: 40,
                  color: AppTheme.primaryRed,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Livreur ClicEat',
                textAlign: TextAlign.center,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppTheme.honey,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '4.8 (124 notes)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Paramètres du compte'),
              _buildListTile(
                context,
                icon: Icons.person_outline,
                title: 'Informations personnelles',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Portefeuille & Retraits',
                onTap: () => context.push('/delivery/payouts'),
              ),
              _buildListTile(
                context,
                icon: Icons.map_outlined,
                title: 'Zones de livraison préférées',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.airport_shuttle_outlined,
                title: 'Mon Véhicule (Moto)',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Configuration App'),
              _buildSwitchTile(
                context,
                icon: Icons.notifications_active_outlined,
                title: 'Sons de mission (Fort)',
                value: true,
                onChanged: (v) {},
              ),
              _buildSwitchTile(
                context,
                icon: Icons.directions_outlined,
                title: 'Navigation Auto-start',
                value: true,
                onChanged: (v) {},
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: Text('delivery.switch_client_mode'.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryRed,
                    side: const BorderSide(
                      color: AppTheme.primaryRed,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.read<AuthBloc>().add(
                      const AuthEvent.switchMode(mode: 'client'),
                    );
                    context.go('/client');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryRed,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.bgWarm,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.inkSoft, size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppTheme.ink,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.mutedLight,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.bgWarm,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.inkSoft, size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppTheme.ink,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primaryRed,
      ),
    );
  }
}

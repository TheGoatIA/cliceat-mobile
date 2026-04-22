import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../client/profile/presentation/pages/profile_page.dart'
    show NotificationSettingsSheet;

class DeliveryProfilePage extends StatefulWidget {
  const DeliveryProfilePage({super.key});

  @override
  State<DeliveryProfilePage> createState() => _DeliveryProfilePageState();
}

class _DeliveryProfilePageState extends State<DeliveryProfilePage> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final result = await getIt<UserRepository>().getProfile();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (user) => setState(() {
        _user = user;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'profile.title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primaryRed, strokeWidth: 2))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 8),
                  _buildMenuSection(context, theme),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final name = _user?.name ?? 'Livreur';
    final email = _user?.email ?? '';
    final phone = _user?.phone ?? '';
    final photo = _user?.avatar;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.redDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: photo != null ? NetworkImage(photo) : null,
            child: photo == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'L',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.bricolageGrotesque(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'delivery.driver_badge'.tr(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              email,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              phone,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('profile.account'.tr(), theme),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'profile.edit_profile'.tr(),
            onTap: () => _showEditProfile(context),
          ),
          _buildMenuItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'delivery.payouts'.tr(),
            onTap: () => context.push('/delivery/payouts'),
          ),
          _buildMenuItem(
            icon: Icons.directions_car_outlined,
            title: 'delivery.my_vehicle'.tr(),
            onTap: () => _showVehicleEdit(context),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('profile.settings'.tr(), theme),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'profile.notifications'.tr(),
            onTap: () => _showNotificationSettings(context),
          ),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: 'profile.language'.tr(),
            onTap: () => _showLanguagePicker(context),
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'profile.help'.tr(),
            onTap: () => _showHelp(context),
          ),
          const SizedBox(height: 16),
          _buildLogoutButton(context, theme),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
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

  Widget _buildMenuItem({
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
              fontWeight: FontWeight.w500, fontSize: 14, color: AppTheme.ink),
        ),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppTheme.mutedLight),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                'profile.logout_confirm_title'.tr(),
                style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppTheme.ink),
              ),
              content: Text(
                'profile.logout_confirm_message'.tr(),
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppTheme.inkSoft),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('common.cancel'.tr(),
                      style: GoogleFonts.inter(color: AppTheme.muted)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(const AuthEvent.logout());
                  },
                  child: Text(
                    'profile.logout'.tr(),
                    style: GoogleFonts.inter(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryRed,
          side: const BorderSide(color: AppTheme.primaryRed, width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          textStyle:
              GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.logout, size: 18),
        label: Text('profile.logout'.tr()),
      ),
    );
  }

  void _showVehicleEdit(BuildContext context) {
    String selectedVehicleType = 'motorcycle';
    final plateCtrl = TextEditingController();
    final theme = Theme.of(context);

    const vehicleTypes = [
      ('motorcycle', 'delivery.vehicle_motorcycle'),
      ('bicycle', 'delivery.vehicle_bicycle'),
      ('car', 'delivery.vehicle_car'),
      ('on_foot', 'delivery.vehicle_on_foot'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
              left: 24, right: 24, top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('delivery.my_vehicle'.tr(),
                  style: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w700, fontSize: 20, color: AppTheme.ink)),
              const SizedBox(height: 16),
              Text('delivery.vehicle_type'.tr(),
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.inkSoft)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: vehicleTypes.map((vt) {
                  final (value, labelKey) = vt;
                  final selected = selectedVehicleType == value;
                  return ChoiceChip(
                    label: Text(labelKey.tr()),
                    selected: selected,
                    onSelected: (_) => setSheetState(() => selectedVehicleType = value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: plateCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'delivery.vehicle_plate'.tr(),
                  hintText: 'LT 1234 CM',
                  prefixIcon: const Icon(Icons.pin_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await getIt<UserRepository>().updateProfile({
                      'deliveryman': {
                        'vehicleType': selectedVehicleType,
                        'vehiclePlate':
                            plateCtrl.text.trim().toUpperCase(),
                      }
                    });
                    _loadProfile();
                  },
                  child: Text('common.save'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    final nameController = TextEditingController(text: _user?.name ?? '');
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('profile.edit_profile'.tr(),
                style: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w700, fontSize: 20, color: AppTheme.ink)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'profile.name'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await getIt<UserRepository>().updateProfile(
                      {'name': nameController.text.trim()});
                  _loadProfile();
                },
                child: Text('common.save'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => const NotificationSettingsSheet(),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('profile.language'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇫🇷', style: TextStyle(fontSize: 24)),
              title: const Text('Français'),
              trailing: context.locale == const Locale('fr', 'FR')
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                context.setLocale(const Locale('fr', 'FR'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: context.locale == const Locale('en', 'US')
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                context.setLocale(const Locale('en', 'US'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.help_outline, size: 48, color: AppTheme.primaryRed),
            const SizedBox(height: 16),
            Text(
              'profile.help'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppTheme.ink),
            ),
            const SizedBox(height: 16),
            Text('support@cliceat.cm',
                style: GoogleFonts.inter(fontSize: 16, color: AppTheme.ink, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('WhatsApp: +237 699 000 000',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cliceat_app/core/di/injection.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.title'.tr()),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
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
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            backgroundImage: photo != null ? NetworkImage(photo) : null,
            child: photo == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'L',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'delivery.driver_badge'.tr(),
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              phone,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
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
          const SizedBox(height: 8),
          _buildSectionTitle('profile.account'.tr(), theme),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'profile.edit_profile'.tr(),
            onTap: () => _showEditProfile(context),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
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
      child: OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('profile.logout_confirm_title'.tr()),
              content: Text('profile.logout_confirm_message'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('common.cancel'.tr()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(const AuthEvent.logout());
                  },
                  child: Text(
                    'profile.logout'.tr(),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(color: theme.colorScheme.error),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.logout),
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
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('delivery.vehicle_type'.tr(), style: theme.textTheme.labelLarge),
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
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
            Icon(Icons.help_outline,
                size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('profile.help'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('support@cliceat.cm',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('WhatsApp: +237 699 000 000',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

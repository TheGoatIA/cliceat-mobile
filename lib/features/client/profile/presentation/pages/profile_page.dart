import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cliceat_app/di/injection.dart';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:cliceat_app/features/client/profile/data/models/loyalty_model.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final name = _user?.name ?? 'profile.default_name'.tr();
    final email = _user?.email ?? '';
    final phone = _user?.phone ?? '';
    final photo = _user?.avatar;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(color: theme.colorScheme.primary),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor:
                theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            backgroundImage: photo != null ? NetworkImage(photo) : null,
            child: photo == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
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
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
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
            icon: Icons.location_on_outlined,
            title: 'profile.my_addresses'.tr(),
            onTap: () => _showAddresses(context),
          ),
          _buildMenuItem(
            icon: Icons.card_giftcard_outlined,
            title: 'profile.loyalty'.tr(),
            onTap: () => _showLoyalty(context),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('profile.orders'.tr(), theme),
          _buildMenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'profile.order_history'.tr(),
            onTap: () => context.push('/client/orders'),
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
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
        onTap: () {
          HapticFeedback.lightImpact();
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
          onTap();
        },
      ),
    );
  }
<<<<<<< HEAD

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.logout),
        label: Text('profile.logout'.tr()),
      ),
    );
  }

  // ── Modals ──────────────────────────────────────────────────────────────────

  void _showEditProfile(BuildContext context) {
    final nameController =
        TextEditingController(text: _user?.name ?? '');
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'profile.edit_profile'.tr(),
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'profile.name'.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final result = await getIt<UserRepository>()
                      .updateProfile({'name': nameController.text.trim()});
                  result.fold(
                    (err) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err.message.tr())),
                        );
                      }
                    },
                    (user) {
                      if (mounted) setState(() => _user = user);
                    },
                  );
                },
                child: Text('common.save'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (_, scrollController) => FutureBuilder<
            List<AddressModel>>(
          future: getIt<UserRepository>()
              .getAddresses()
              .then((r) => r.fold((_) => <AddressModel>[], (a) => a)),
          builder: (context, snapshot) {
            final addresses = snapshot.data ?? [];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'profile.my_addresses'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: addresses.isEmpty
                      ? Center(
                          child: Text('profile.no_addresses'.tr()))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: addresses.length,
                          itemBuilder: (_, i) {
                            final addr = addresses[i];
                            return Dismissible(
                              key: Key(addr.id.isNotEmpty
                                  ? addr.id
                                  : 'addr_$i'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.only(right: 16),
                                child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                if (addr.id.isEmpty) return false;
                                final result =
                                    await getIt<UserRepository>()
                                        .deleteAddress(addr.id);
                                return result.isRight();
                              },
                              child: ListTile(
                                leading: const Icon(
                                    Icons.location_on_outlined),
                                title: Text(addr.address),
                                subtitle: addr.label != null
                                    ? Text(addr.label!)
                                    : null,
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color:
                                        Theme.of(context)
                                            .colorScheme
                                            .error,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    if (addr.id.isEmpty) return;
                                    final result =
                                        await getIt<UserRepository>()
                                            .deleteAddress(addr.id);
                                    if (result.isRight() &&
                                        context.mounted) {
                                      Navigator.pop(context);
                                      _showAddresses(context);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLoyalty(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => FutureBuilder<LoyaltyModel?>(
        future: getIt<UserRepository>()
            .getLoyalty()
            .then((r) => r.fold((_) => null, (l) => l)),
        builder: (context, snapshot) {
          final theme = Theme.of(context);
          final points = snapshot.data?.points ?? 0;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.card_giftcard,
                    size: 64, color: theme.colorScheme.secondary),
                const SizedBox(height: 16),
                Text(
                  'profile.loyalty'.tr(),
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '$points pts',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'profile.loyalty_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
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
            Text(
              'profile.language'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading:
                  const Text('🇫🇷', style: TextStyle(fontSize: 24)),
              title: const Text('Français'),
              trailing:
                  context.locale == const Locale('fr', 'FR')
                      ? const Icon(Icons.check)
                      : null,
              onTap: () {
                context.setLocale(const Locale('fr', 'FR'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading:
                  const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing:
                  context.locale == const Locale('en', 'US')
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
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'profile.help'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('support@cliceat.cm',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('WhatsApp: +237 6XX XXX XXX',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
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
      builder: (_) => const NotificationSettingsSheet(),
    );
  }
}

// ── Notification Settings Sheet ─────────────────────────────────────────────

/// Notification preference toggles backed by [SharedPreferences].
class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({super.key});

  @override
  State<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends State<NotificationSettingsSheet> {
  static const _keyOrderUpdates = 'notif_order_updates';
  static const _keyPromotions = 'notif_promotions';
  static const _keyNewRestaurants = 'notif_new_restaurants';

  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newRestaurants = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _orderUpdates = prefs.getBool(_keyOrderUpdates) ?? true;
      _promotions = prefs.getBool(_keyPromotions) ?? true;
      _newRestaurants = prefs.getBool(_keyNewRestaurants) ?? false;
      _loaded = true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile.notifications'.tr(),
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'profile.notifications_subtitle'.tr(),
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          if (!_loaded)
            const Center(child: CircularProgressIndicator())
          else ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.receipt_long,
                  color: theme.colorScheme.primary),
              title: Text('profile.notif_order_updates'.tr()),
              subtitle:
                  Text('profile.notif_order_updates_desc'.tr()),
              value: _orderUpdates,
              onChanged: (v) {
                setState(() => _orderUpdates = v);
                _save(_keyOrderUpdates, v);
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.local_offer,
                  color: theme.colorScheme.secondary),
              title: Text('profile.notif_promotions'.tr()),
              subtitle:
                  Text('profile.notif_promotions_desc'.tr()),
              value: _promotions,
              onChanged: (v) {
                setState(() => _promotions = v);
                _save(_keyPromotions, v);
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.restaurant_menu,
                  color: theme.colorScheme.tertiary),
              title: Text('profile.notif_new_restaurants'.tr()),
              subtitle:
                  Text('profile.notif_new_restaurants_desc'.tr()),
              value: _newRestaurants,
              onChanged: (v) {
                setState(() => _newRestaurants = v);
                _save(_keyNewRestaurants, v);
              },
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
=======
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/user_service.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final res = await getIt<UserService>().getMe();
      if (res.isSuccessful && res.body != null) {
        final body = res.body!;
        setState(() {
          _userData = (body['data'] as Map<String, dynamic>?) ?? body;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
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
    final name = _userData?['name'] as String? ?? 'profile.default_name'.tr();
    final email = _userData?['email'] as String? ?? '';
    final phone = _userData?['phone'] as String? ?? '';
    final photo = _userData?['photo'] as String?;

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
            onTap: () {},
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

  void _showEditProfile(BuildContext context) {
    final nameController = TextEditingController(
        text: _userData?['name'] as String? ?? '');
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
                  try {
                    await getIt<UserService>().updateMe({'name': nameController.text.trim()});
                    _loadProfile();
                  } catch (_) {}
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
        builder: (_, scrollController) => FutureBuilder(
          future: getIt<UserService>().getAddresses(),
          builder: (context, snapshot) {
            List<dynamic> addresses = [];
            if (snapshot.hasData && snapshot.data!.isSuccessful) {
              final body = snapshot.data!.body;
              addresses = (body?['data'] as List<dynamic>?) ?? [];
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('profile.my_addresses'.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: addresses.isEmpty
                      ? Center(child: Text('profile.no_addresses'.tr()))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: addresses.length,
                          itemBuilder: (_, i) {
                            final addr = addresses[i] as Map<String, dynamic>;
                            return ListTile(
                              leading: const Icon(Icons.location_on_outlined),
                              title: Text(addr['address']?.toString() ?? ''),
                              subtitle: addr['label'] != null
                                  ? Text(addr['label'].toString())
                                  : null,
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇫🇷', style: TextStyle(fontSize: 24)),
              title: const Text('Français'),
              trailing: context.locale == const Locale('fr', 'FR') ? const Icon(Icons.check) : null,
              onTap: () {
                context.setLocale(const Locale('fr', 'FR'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: context.locale == const Locale('en', 'US') ? const Icon(Icons.check) : null,
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
            Icon(Icons.help_outline, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('profile.help'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('support@cliceat.cm', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('WhatsApp: +237 6XX XXX XXX', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showLoyalty(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => FutureBuilder(
        future: getIt<UserService>().getLoyalty(),
        builder: (context, snapshot) {
          final theme = Theme.of(context);
          int points = 0;
          if (snapshot.hasData && snapshot.data!.isSuccessful) {
            final body = snapshot.data!.body;
            final data = (body?['data'] as Map<String, dynamic>?) ?? {};
            points = (data['points'] as int?) ?? 0;
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.card_giftcard, size: 64, color: theme.colorScheme.secondary),
                const SizedBox(height: 16),
                Text('profile.loyalty'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '$points pts',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('profile.loyalty_desc'.tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}

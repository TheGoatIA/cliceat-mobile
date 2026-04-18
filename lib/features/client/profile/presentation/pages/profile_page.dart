import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/user_profile_service.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _loyalty;
  List<dynamic> _addresses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final service = getIt<UserProfileService>();
      final results = await Future.wait([
        service.getProfile(),
        service.getLoyalty(),
        service.getAddresses(),
      ]);

      if (results[0].isSuccessful) {
        final data = results[0].body as Map<String, dynamic>;
        _profile = data['data'] as Map<String, dynamic>?;
      }
      if (results[1].isSuccessful) {
        final data = results[1].body as Map<String, dynamic>;
        _loyalty = data['data'] as Map<String, dynamic>?;
      }
      if (results[2].isSuccessful) {
        final data = results[2].body as Map<String, dynamic>;
        _addresses = (data['data'] as List?) ?? [];
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Avatar + name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: _profile?['avatar'] != null
                              ? NetworkImage(_profile!['avatar'] as String)
                              : null,
                          child: _profile?['avatar'] == null
                              ? const Icon(Icons.person, size: 48)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _profile?['name'] as String? ?? '',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _profile?['email'] as String? ||
                                  _profile?['phone'] as String? ??
                              '',
                          style: TextStyle(
                              color: theme.colorScheme.outline),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Loyalty card
                  if (_loyalty != null) ...
                    [
                      _SectionTitle(title: 'profile.loyalty'.tr()),
                      Card(
                        color: theme.colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.stars, size: 32),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_loyalty!['points'] ?? 0} points',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text('profile.loyalty_subtitle'.tr()),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () =>
                                    context.push('/profile/loyalty'),
                                child: Text('profile.history'.tr()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                  // Addresses
                  _SectionTitle(title: 'profile.addresses'.tr()),
                  ..._addresses.map((addr) {
                    final a = addr as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(a['label'] as String? ?? 'Adresse'),
                      subtitle: Text(a['address'] as String? ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final id = a['_id'] as String? ?? '';
                          await getIt<UserProfileService>()
                              .deleteAddress(id);
                          await _load();
                        },
                      ),
                    );
                  }),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text('profile.add_address'.tr()),
                    onPressed: () =>
                        context.push('/profile/addresses/new'),
                  ),

                  const Divider(height: 32),

                  // Settings
                  _SectionTitle(title: 'profile.settings'.tr()),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text('profile.language'.tr()),
                    trailing: DropdownButton<Locale>(
                      value: context.locale,
                      items: const [
                        DropdownMenuItem(
                          value: Locale('fr', 'FR'),
                          child: Text('Français'),
                        ),
                        DropdownMenuItem(
                          value: Locale('en', 'US'),
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (locale) {
                        if (locale != null) {
                          context.setLocale(locale);
                        }
                      },
                      underline: const SizedBox.shrink(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logout
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: Text('auth.logout'.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                          color: theme.colorScheme.error),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEvent.logout());
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

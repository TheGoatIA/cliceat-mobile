import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:cliceat_app/features/client/profile/data/models/loyalty_model.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/core/theme/presentation/bloc/theme_cubit.dart';
import 'package:cliceat_app/core/config/feature_flags.dart';
import 'package:cliceat_app/core/widgets/feature_gate.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator())),
          error: (msg) => Scaffold(body: Center(child: Text(msg))),
          loaded: (user) => _buildProfileContent(context, user, theme),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user, ThemeData theme) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(theme, user),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: _buildMenuSection(context, theme, user),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(ThemeData theme, UserModel user) {
    final name = user.name;
    final email = user.email ?? '';
    final phone = user.phone ?? '';
    final photo = user.avatar;

    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      backgroundColor: AppTheme.primaryRed,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: const SizedBox.shrink(),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryRed, AppTheme.redDeep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Avatar avec badge edit
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.2),
                        backgroundImage: photo != null &&
                                photo.isNotEmpty
                            ? NetworkImage(photo)
                            : null,
                        child: photo == null || photo.isEmpty
                            ? Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showEditProfile(context, user),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (email.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                if (phone.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      phone,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ThemeData theme, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Section Mon Compte
        _buildSectionHeader('profile.account'.tr(), theme),
        const SizedBox(height: 8),
        _buildMenuGroup([
          _buildMenuItem(
            icon: Icons.person_outline_rounded,
            title: 'profile.edit_profile'.tr(),
            color: AppTheme.primaryRed,
            onTap: () => _showEditProfile(context, user),
          ),
          _buildDivider(theme),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'profile.my_addresses'.tr(),
            color: AppTheme.statusPending,
            onTap: () => _showAddresses(context),
          ),
          _buildDivider(theme),
          FeatureGate(
            featureKey: FeatureFlags.wallet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'wallet.title'.tr(),
                  color: AppTheme.green,
                  onTap: () => context.push('/client/wallet'),
                ),
                _buildDivider(theme),
              ],
            ),
          ),
          FeatureGate(
            featureKey: FeatureFlags.loyalty,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  icon: Icons.card_giftcard_outlined,
                  title: 'profile.loyalty'.tr(),
                  color: AppTheme.honey,
                  onTap: () => _showLoyalty(context),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.honeySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'profile.points'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.honey,
                      ),
                    ),
                  ),
                ),
                _buildDivider(theme),
              ],
            ),
          ),
          FeatureGate(
            featureKey: FeatureFlags.referral,
            child: _buildMenuItem(
              icon: Icons.group_add_outlined,
              title: 'referral.title'.tr(),
              color: AppTheme.honey,
              onTap: () => context.push('/client/profile/referrals'),
            ),
          ),
        ], theme),

        const SizedBox(height: 20),

        // Section Commandes
        _buildSectionHeader('profile.orders'.tr(), theme),
        const SizedBox(height: 8),
        _buildMenuGroup([
          _buildMenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'profile.order_history'.tr(),
            color: AppTheme.primaryRed,
            onTap: () => context.push('/client/orders'),
          ),
          _buildDivider(theme),
          _buildMenuItem(
            icon: Icons.rate_review_outlined,
            title: 'review.my_reviews'.tr(),
            color: AppTheme.honey,
            onTap: () => context.push('/client/profile/reviews'),
          ),
          _buildDivider(theme),
          _buildMenuItem(
            icon: Icons.gavel_outlined,
            title: 'dispute.history_title'.tr(),
            color: AppTheme.errorColor,
            onTap: () => context.push('/client/dispute/history'),
          ),
        ], theme),

        const SizedBox(height: 20),

        // Section Paramètres
        _buildSectionHeader('profile.settings'.tr(), theme),
        const SizedBox(height: 8),
        _buildMenuGroup([
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'profile.notifications'.tr(),
            color: AppTheme.honey,
            onTap: () => _showNotificationSettings(context),
          ),
          _buildDivider(theme),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: 'profile.language'.tr(),
            color: AppTheme.green,
            onTap: () => _showLanguagePicker(context),
          ),
          _buildDivider(theme),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return _buildSwitchTile(
                icon: mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                title: 'profile.dark_mode'.tr(),
                value: mode == ThemeMode.dark,
                onChanged: (v) {
                  context.read<ThemeCubit>().setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                },
              );
            },
          ),
          _buildDivider(theme),
          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            title: 'profile.help'.tr(),
            color: AppTheme.green,
            onTap: () => _showHelp(context),
          ),
        ], theme),

        const SizedBox(height: 28),

        // Logout button
        _buildLogoutButton(context, theme),

        const SizedBox(height: 16),

        // Version info
        Center(
          child: Text(
            'ClicEat v1.0.0',
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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

  Widget _buildMenuGroup(List<Widget> children, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 56,
      color: AppTheme.lineSoft,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppTheme.mutedLight),
            ],
          ),
        ),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text('profile.logout_confirm_title'.tr()),
              content: Text('profile.logout_confirm_message'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('common.cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<AuthBloc>()
                        .add(const AuthEvent.logout());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('profile.logout'.tr()),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.errorColor,
          side: const BorderSide(color: AppTheme.errorColor),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: Text('profile.logout'.tr()),
      ),
    );
  }

  // ── Modals ──────────────────────────────────────────────────────────────────

  void _showEditProfile(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'profile.edit_profile'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'profile.name'.tr(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final result = await getIt<UserRepository>()
                      .updateProfile(
                          {'name': nameController.text.trim()});
                  result.fold(
                    (err) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err.message.tr())),
                        );
                      }
                    },
                    (updatedUser) {
                      // ProfileCubit will handle the state update and UI refresh
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text('common.save'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === FIX: Ajout d'adresse implémenté ===
  void _showAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          Future<List<AddressModel>> futureAddresses =
              getIt<UserRepository>()
                  .getAddresses()
                  .then((r) => r.fold((_) => <AddressModel>[], (a) => a));

          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) => Column(
              children: [
                // Handle + header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.lineSoft,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'profile.my_addresses'.tr(),
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // === BOUTON AJOUTER — implémenté ===
                          IconButton(
                            icon: const Icon(
                                Icons.add_circle_outline_rounded),
                            color: AppTheme.primaryRed,
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showAddAddressForm(context);
                            },
                            tooltip: 'profile.add_address'.tr(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<AddressModel>>(
                    future: futureAddresses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      final addresses = snapshot.data ?? [];
                      if (addresses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                size: 48,
                                color: AppTheme.muted.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'profile.no_addresses'.tr(),
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: AppTheme.muted),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _showAddAddressForm(context);
                                },
                                icon: const Icon(Icons.add),
                                label: Text(
                                    'profile.add_address'.tr()),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: addresses.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final addr = addresses[i];
                          return Dismissible(
                            key: Key(addr.id.isNotEmpty
                                ? addr.id
                                : 'addr_$i'),
                            direction:
                                DismissDirection.endToStart,
                            background: Container(
                              padding: const EdgeInsets.only(
                                  right: 20),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor,
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              if (addr.id.isEmpty) return false;
                              final result =
                                  await getIt<UserRepository>()
                                      .deleteAddress(addr.id);
                              return result.isRight();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.lineSoft),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppTheme.redSoft,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      color: AppTheme.primaryRed,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (addr.label != null)
                                          Text(
                                            addr.label!,
                                            style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        Text(
                                          addr.address,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppTheme.muted,
                                          ),
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Implémenté: formulaire ajout d'adresse → POST /users/me/addresses
  void _showAddAddressForm(BuildContext context) {
    final addressCtrl = TextEditingController();
    final labelCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'profile.add_address'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: labelCtrl,
              decoration: InputDecoration(
                labelText: 'profile.address_label'.tr(),
                hintText: 'profile.address_label_hint'.tr(),
                prefixIcon: const Icon(Icons.bookmark_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'profile.address_street'.tr(),
                hintText: 'profile.address_street_hint'.tr(),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (ctx, setLocalState) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final address = addressCtrl.text.trim();
                    if (address.isEmpty) return;

                    Navigator.pop(ctx);

                    final result =
                        await getIt<UserRepository>().addAddress({
                      'address': address,
                      if (labelCtrl.text.trim().isNotEmpty)
                        'label': labelCtrl.text.trim(),
                    });

                    result.fold(
                      (err) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err.message.tr()),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                        }
                      },
                      (_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('profile.address_added'.tr()),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                          _showAddresses(context);
                        }
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('common.add'.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoyalty(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => FutureBuilder<LoyaltyModel?>(
        future: getIt<UserRepository>()
            .getLoyalty()
            .then((r) => r.fold((_) => null, (l) => l)),
        builder: (context, snapshot) {
          final points = snapshot.data?.points ?? 0;
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.lineSoft,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Points badge
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.honey, AppTheme.honeyLight],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$points',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'pts',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'profile.loyalty'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'profile.loyalty_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 16),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'profile.language'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildLanguageTile(ctx, 'Français', '🇫🇷', const Locale('fr', 'FR')),
            _buildLanguageTile(ctx, 'English', '🇬🇧', const Locale('en', 'US')),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
      BuildContext ctx, String lang, String flag, Locale locale) {
    final isSelected = ctx.locale == locale;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ctx.setLocale(locale);
          Navigator.pop(ctx);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lang,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle_rounded,
                    color: AppTheme.primaryRed, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppTheme.greenSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.help_outline_rounded,
                  size: 32, color: AppTheme.green),
            ),
            const SizedBox(height: 16),
            Text(
              'profile.help'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('support@cliceat.cm',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('WhatsApp: +237 6XX XXX XXX',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted)),
            const SizedBox(height: 16),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const NotificationSettingsSheet(),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.bgWarm,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.inkSoft, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ── Notification Settings Sheet ─────────────────────────────────────────────

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.lineSoft,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'profile.notifications'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'profile.notifications_subtitle'.tr(),
            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
          ),
          const SizedBox(height: 20),
          if (!_loaded)
            const Center(child: CircularProgressIndicator())
          else ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.redSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long,
                    color: AppTheme.primaryRed, size: 20),
              ),
              title: Text('profile.notif_order_updates'.tr()),
              subtitle: Text('profile.notif_order_updates_desc'.tr()),
              value: _orderUpdates,
              onChanged: (v) {
                setState(() => _orderUpdates = v);
                _save(_keyOrderUpdates, v);
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.honeySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_offer,
                    color: AppTheme.honey, size: 20),
              ),
              title: Text('profile.notif_promotions'.tr()),
              subtitle: Text('profile.notif_promotions_desc'.tr()),
              value: _promotions,
              onChanged: (v) {
                setState(() => _promotions = v);
                _save(_keyPromotions, v);
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.greenSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.restaurant_menu,
                    color: AppTheme.green, size: 20),
              ),
              title: Text('profile.notif_new_restaurants'.tr()),
              subtitle: Text('profile.notif_new_restaurants_desc'.tr()),
              value: _newRestaurants,
              onChanged: (v) {
                setState(() => _newRestaurants = v);
                _save(_keyNewRestaurants, v);
              },
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

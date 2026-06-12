import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/shared/models/address_model.dart';
import 'package:cliceat_app/features/client/profile/data/models/loyalty_model.dart';
import 'package:cliceat_app/shared/models/user_model.dart';
import 'package:cliceat_app/features/client/profile/data/repositories/user_repository.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/core/config/feature_flags.dart';
import 'package:cliceat_app/core/widgets/feature_gate.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:cliceat_app/core/errors/app_error.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (msg) => Scaffold(body: Center(child: Text(msg))),
          loaded: (user) => _buildProfileContent(context, user, theme),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    UserModel user,
    ThemeData theme,
  ) {
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
                      child: ClipOval(
                        child: photo != null && photo.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: photo,
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 96,
                                  height: 96,
                                  color: Colors.white.withValues(alpha: 0.2),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  debugPrint(
                                    "Avatar image failed to load: $error",
                                  );
                                  return Container(
                                    width: 96,
                                    height: 96,
                                    color: Colors.white.withValues(alpha: 0.2),
                                    alignment: Alignment.center,
                                    child: Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : 'U',
                                      style: GoogleFonts.bricolageGrotesque(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 96,
                                height: 96,
                                color: Colors.white.withValues(alpha: 0.2),
                                alignment: Alignment.center,
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                  style: GoogleFonts.bricolageGrotesque(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _pickAndUploadAvatar(context),
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

  Widget _buildMenuSection(
    BuildContext context,
    ThemeData theme,
    UserModel user,
  ) {
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
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
          // Dark Mode toggle is hidden for now, keeping only light theme
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
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppTheme.mutedLight,
                ),
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
                borderRadius: BorderRadius.circular(20),
              ),
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
                    context.go('/auth/login');
                    context.read<AuthBloc>().add(const AuthEvent.logout());
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: Text('profile.logout'.tr()),
      ),
    );
  }

  // ── Modals ──────────────────────────────────────────────────────────────────

  void _showEditProfile(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone ?? '');
    final formKey = GlobalKey<FormState>();
    // Determine initial city: normalize stored value to one of the two options
    const cities = ['Douala', 'Yaoundé'];
    String selectedCity = cities.firstWhere(
      (c) =>
          c.toLowerCase().replaceAll('é', 'e') ==
          (user.city ?? '').toLowerCase(),
      orElse: () => cities.first,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
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
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'profile.name'.tr(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'profile.name_required'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'profile.phone'.tr(),
                    hintText: '+237 6XX XXX XXX',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    helperText: 'profile.phone_required'.tr(),
                    helperStyle: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.muted,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'profile.phone_required'.tr();
                    }
                    final phoneRegex = RegExp(
                      r'^\+?237[0-9]{8,9}$|^6[0-9]{8}$',
                    );
                    if (!phoneRegex.hasMatch(
                      value.trim().replaceAll(' ', ''),
                    )) {
                      return 'profile.phone_invalid'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: selectedCity,
                  decoration: InputDecoration(
                    labelText: 'profile.city'.tr(),
                    prefixIcon: const Icon(Icons.location_city_outlined),
                  ),
                  items: cities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => selectedCity = value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      Navigator.pop(ctx);
                      final payload = <String, dynamic>{
                        'name': nameController.text.trim(),
                        'city': selectedCity.toLowerCase().replaceAll('é', 'e'),
                      };
                      final phone = phoneController.text.trim();
                      if (phone.isNotEmpty) payload['phone'] = phone;
                      final result = await getIt<UserRepository>()
                          .updateProfile(payload);
                      result.fold(
                        (err) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err.message.tr())),
                            );
                          }
                        },
                        (updatedUser) {
                          if (mounted) {
                            context.read<ProfileCubit>().emitLoaded(
                              updatedUser,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('profile.update_success'.tr()),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('common.save'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === photo / avatar select ===
  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    try {
      HapticFeedback.lightImpact();
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image == null) return;

      if (!context.mounted) return;
      final file = File(image.path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
              Text('profile.photo_updating'.tr()),
            ],
          ),
          duration: const Duration(seconds: 10),
        ),
      );

      final result = await getIt<UserRepository>().updateProfilePhoto(file);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      result.fold(
        (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.message.tr()),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        },
        (updatedUser) {
          context.read<ProfileCubit>().emitLoaded(updatedUser);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('profile.photo_update_success'.tr()),
              backgroundColor: AppTheme.successColor,
            ),
          );
        },
      );
    } catch (e, s) {
      debugPrint('[profile_page.dart] error: $e\n$s');
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('common.error'.tr()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  // === FIX: Ajout et modification d'adresse implémentés ===
  void _showAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const MyAddressesSheet(),
    );
  }

  void _showLoyalty(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FutureBuilder<LoyaltyModel?>(
        future: getIt<UserRepository>().getLoyalty().then(
          (r) => r.fold((_) => null, (l) => l),
        ),
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
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
            _buildLanguageTile(
              ctx,
              'Français',
              '🇫🇷',
              const Locale('fr', 'FR'),
            ),
            _buildLanguageTile(
              ctx,
              'English',
              '🇬🇧',
              const Locale('en', 'US'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext ctx,
    String lang,
    String flag,
    Locale locale,
  ) {
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.primaryRed,
                  size: 22,
                ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
              'profile.help'.tr(),
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 20),
            // Phone tile
            _buildSupportTile(
              icon: Icons.phone_rounded,
              iconColor: AppTheme.green,
              iconBg: AppTheme.greenSoft,
              title: 'support.call_support'.tr(),
              subtitle: 'support.phone_number'.tr(),
              onTap: () async {
                final uri = Uri.parse('tel:+237658709986');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
            ),
            const SizedBox(height: 10),
            // WhatsApp tile
            _buildSupportTile(
              icon: Icons.chat_bubble_outline_rounded,
              iconColor: const Color(0xFF25D366),
              iconBg: const Color(0xFFE8F5E9),
              title: 'support.whatsapp'.tr(),
              subtitle: 'support.phone_number'.tr(),
              onTap: () async {
                final uri = Uri.parse('https://wa.me/237658709986');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: 10),
            // Email tile
            _buildSupportTile(
              icon: Icons.email_outlined,
              iconColor: AppTheme.primaryRed,
              iconBg: AppTheme.redSoft,
              title: 'support.email'.tr(),
              subtitle: 'support.email'.tr(),
              onTap: () async {
                final uri = Uri.parse('mailto:support@cliceat.cm');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.lineSoft),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.ink,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.mutedLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const NotificationSettingsSheet(),
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

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
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

    bool orderUpdates = prefs.getBool(_keyOrderUpdates) ?? true;
    bool promotions = prefs.getBool(_keyPromotions) ?? true;
    bool newRestaurants = prefs.getBool(_keyNewRestaurants) ?? false;

    if (mounted) {
      final profileState = context.read<ProfileCubit>().state;
      profileState.maybeWhen(
        loaded: (user) {
          if (user.notificationPreferences != null) {
            orderUpdates =
                user.notificationPreferences!['orderUpdates'] as bool? ??
                orderUpdates;
            promotions =
                user.notificationPreferences!['promotions'] as bool? ??
                promotions;
            newRestaurants =
                user.notificationPreferences!['newRestaurants'] as bool? ??
                newRestaurants;
          }
        },
        orElse: () {},
      );

      setState(() {
        _orderUpdates = orderUpdates;
        _promotions = promotions;
        _newRestaurants = newRestaurants;
        _loaded = true;
      });

      // Save locally
      await prefs.setBool(_keyOrderUpdates, _orderUpdates);
      await prefs.setBool(_keyPromotions, _promotions);
      await prefs.setBool(_keyNewRestaurants, _newRestaurants);
    }
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    // Sync with remote server
    try {
      await getIt<UserRepository>().updateProfile({
        'notificationPreferences': {
          'orderUpdates': _orderUpdates,
          'promotions': _promotions,
          'newRestaurants': _newRestaurants,
        },
      });

      if (mounted) {
        final profileCubit = context.read<ProfileCubit>();
        profileCubit.state.maybeWhen(
          loaded: (user) {
            final updatedUser = user.copyWith(
              notificationPreferences: {
                'orderUpdates': _orderUpdates,
                'promotions': _promotions,
                'newRestaurants': _newRestaurants,
              },
            );
            profileCubit.emitLoaded(updatedUser);
          },
          orElse: () {},
        );
      }
    } catch (e, s) {
      debugPrint('[profile_page.dart] error: $e\n$s');
    }
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
                child: const Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryRed,
                  size: 20,
                ),
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
                child: const Icon(
                  Icons.local_offer,
                  color: AppTheme.honey,
                  size: 20,
                ),
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
                child: const Icon(
                  Icons.restaurant_menu,
                  color: AppTheme.green,
                  size: 20,
                ),
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

// ── MyAddressesSheet Component ─────────────────────────────────────────────

class MyAddressesSheet extends StatefulWidget {
  const MyAddressesSheet({super.key});

  @override
  State<MyAddressesSheet> createState() => _MyAddressesSheetState();
}

class _MyAddressesSheetState extends State<MyAddressesSheet> {
  List<AddressModel> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final result = await getIt<UserRepository>().getAddresses();
    if (mounted) {
      result.fold(
        (err) => setState(() => _isLoading = false),
        (list) => setState(() {
          _addresses = list;
          _isLoading = false;
        }),
      );
    }
  }

  Future<void> _deleteAddress(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('profile.delete_address_title'.tr()),
        content: const Text(
          "Voulez-vous vraiment supprimer cette adresse de votre compte ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'common.cancel'.tr(),
              style: const TextStyle(color: AppTheme.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      final result = await getIt<UserRepository>().deleteAddress(id);
      result.fold((err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.message.tr()),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          setState(() => _isLoading = false);
        }
      }, (_) => _loadAddresses());
    }
  }

  void _showAddressForm({AddressModel? existingAddress}) {
    final isEditing = existingAddress != null;
    final addressCtrl = TextEditingController(text: existingAddress?.address);
    final labelCtrl = TextEditingController(text: existingAddress?.label);

    double selectedLat = existingAddress?.lat ?? 4.0511;
    double selectedLng = existingAddress?.lng ?? 9.7679;
    bool locationPicked = isEditing;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
              isEditing
                  ? 'profile.edit_address'.tr()
                  : 'profile.add_address'.tr(),
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
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.map_rounded,
                    color: AppTheme.primaryRed,
                  ),
                  tooltip: 'profile.choose_on_map'.tr(),
                  onPressed: () async {
                    HapticFeedback.selectionClick();
                    final result = await context.push(
                      '/map-picker',
                      extra: {
                        'initialLat': selectedLat,
                        'initialLng': selectedLng,
                      },
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      selectedLat = result['lat'] as double;
                      selectedLng = result['lng'] as double;
                      addressCtrl.text = result['address'] as String;
                      locationPicked = true;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final address = addressCtrl.text.trim();
                  if (address.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text('profile.address_empty_error'.tr()),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  if (!locationPicked) {
                    try {
                      final permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.always ||
                          permission == LocationPermission.whileInUse) {
                        final pos = await Geolocator.getCurrentPosition(
                          locationSettings: const LocationSettings(
                            accuracy: LocationAccuracy.low,
                          ),
                        ).timeout(const Duration(seconds: 2));
                        selectedLat = pos.latitude;
                        selectedLng = pos.longitude;
                      }
                    } catch (e, s) {
                      debugPrint('[profile_page.dart] error: $e\n$s');
                    }
                  }

                  final Map<String, dynamic> data = {
                    'address': address,
                    'label': labelCtrl.text.trim().isNotEmpty
                        ? labelCtrl.text.trim()
                        : 'Adresse',
                    'lat': selectedLat,
                    'lng': selectedLng,
                  };

                  setState(() => _isLoading = true);
                  final Either<AppError, dynamic> result;
                  if (isEditing) {
                    result = await getIt<UserRepository>().updateAddress(
                      existingAddress.id,
                      data,
                    );
                  } else {
                    result = await getIt<UserRepository>().addAddress(data);
                  }

                  result.fold(
                    (err) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(err.message.tr()),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                        setState(() => _isLoading = false);
                      }
                    },
                    (_) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'profile.address_updated'.tr()
                                  : 'profile.address_added'.tr(),
                            ),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                        _loadAddresses();
                      }
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEditing ? 'common.save'.tr() : 'common.add'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
      child: Column(
        children: [
          // Drag handle
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

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'profile.my_addresses'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.ink,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
                  color: AppTheme.primaryRed,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _showAddressForm();
                  },
                  tooltip: 'profile.add_address'.tr(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _addresses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 56,
                          color: AppTheme.muted.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'profile.no_addresses'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppTheme.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            _showAddressForm();
                          },
                          icon: const Icon(Icons.add),
                          label: Text('profile.add_address'.tr()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryRed,
                            side: const BorderSide(color: AppTheme.primaryRed),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    itemCount: _addresses.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final addr = _addresses[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.lineSoft),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppTheme.redSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: AppTheme.primaryRed,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Texts
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (addr.label != null &&
                                        addr.label!.isNotEmpty)
                                      Text(
                                        addr.label!,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppTheme.ink,
                                        ),
                                      ),
                                    const SizedBox(height: 2),
                                    Text(
                                      addr.address,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: AppTheme.muted,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Action Row
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                    color: AppTheme.inkSoft,
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      _showAddressForm(existingAddress: addr);
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 20,
                                    ),
                                    color: AppTheme.errorColor,
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      _deleteAddress(addr.id);
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

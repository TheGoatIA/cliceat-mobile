import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  final String mode; // 'client' or 'delivery'
  const LoginPage({super.key, required this.mode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showRegister = false;

  // Email/password login
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _passwordVisible = false;

  // OTP login
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String? _otpPhone;

  // Delivery login
  final _deliveryPhoneCtrl = TextEditingController();
  final _deliveryPasswordCtrl = TextEditingController();
  bool _deliveryPasswordVisible = false;

  // Register
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPasswordCtrl = TextEditingController();
  final _regCityCtrl = TextEditingController();
  bool _regPasswordVisible = false;

  bool get _isDelivery => widget.mode == 'delivery';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _deliveryPhoneCtrl.dispose();
    _deliveryPasswordCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPasswordCtrl.dispose();
    _regCityCtrl.dispose();
    super.dispose();
  }

  void _onAuthenticated(BuildContext context) {
    context.read<AuthBloc>().add(AuthEvent.switchMode(mode: widget.mode));
    if (widget.mode == 'delivery') {
      context.go('/delivery');
    } else {
      context.go('/client');
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      HapticFeedback.mediumImpact();
      final account = await GoogleSignIn.instance.authenticate();
      final auth = account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        if (context.mounted) {
          _showError(context, 'auth.error_google'.tr());
        }
        return;
      }
      if (context.mounted) {
        context
            .read<AuthBloc>()
            .add(AuthEvent.loginWithGoogle(token: idToken));
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context, 'auth.error_google'.tr());
      }
    }
  }

  Future<void> _handleAppleSignIn(BuildContext context) async {
    try {
      HapticFeedback.mediumImpact();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        if (context.mounted) {
          _showError(context, 'auth.error_apple'.tr());
        }
        return;
      }
      if (context.mounted) {
        context
            .read<AuthBloc>()
            .add(AuthEvent.loginWithApple(token: idToken));
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context, 'auth.error_apple'.tr());
      }
    }
  }

  void _showError(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_, _, _) => _onAuthenticated(context),
          otpSent: (phone) => setState(() => _otpPhone = phone),
          emailVerificationRequired: (email) => context.go(
              '/auth/verify-email?email=${Uri.encodeComponent(email)}'),
          error: (message) => _showError(context, message.tr()),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading =
            state.maybeWhen(loading: () => true, orElse: () => false);
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              // Gradient décoratif en haut
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isDelivery
                          ? [
                              const Color(0xFF1565C0),
                              const Color(0xFF0D47A1).withValues(alpha: 0.7),
                              Colors.transparent,
                            ]
                          : [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () => context.go('/onboarding'),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              child: _showRegister && !_isDelivery
                                  ? _buildRegisterForm(
                                      context, theme, isLoading)
                                  : _otpPhone != null
                                      ? _buildOtpForm(
                                          context, theme, isLoading)
                                      : _isDelivery
                                          ? _buildDeliveryLoginForm(
                                              context, theme, isLoading)
                                          : _buildClientLoginForm(
                                              context, theme, isLoading),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Formulaire Client ────────────────────────────────────────────────────

  Widget _buildClientLoginForm(
      BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('client_login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header avec icon
        _buildHeader(
          theme,
          icon: Icons.fastfood_rounded,
          title: 'auth.login_title'.tr(),
          subtitle: 'auth.login_subtitle'.tr(),
          iconColor: Colors.white,
          bgColor: theme.colorScheme.primary,
        ),
        const SizedBox(height: 28),

        // Card formulaire
        _buildCard(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tabs Email / Téléphone
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'auth.email'.tr()),
                    Tab(text: 'auth.phone_hint'.tr()),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 170,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEmailTab(context, isLoading),
                    _buildPhoneTab(context, isLoading),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Actions secondaires
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => context.push('/auth/forgot-password'),
              child: Text(
                'auth.forgot_password'.tr(),
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
            const Text('·', style: TextStyle(color: Colors.grey)),
            TextButton(
              onPressed: () => setState(() => _showRegister = true),
              child: Text(
                'auth.no_account'.tr(),
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),

        // Diviseur ou
        _buildOrDivider(theme),

        // Social Sign-In
        _buildGoogleButton(context),
        if (Platform.isIOS) ...[
          const SizedBox(height: 12),
          SignInWithAppleButton(
            onPressed: () => _handleAppleSignIn(context),
            borderRadius: BorderRadius.circular(12),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  // ─── Formulaire Livreur ───────────────────────────────────────────────────

  Widget _buildDeliveryLoginForm(
      BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('delivery_login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(
          theme,
          icon: Icons.delivery_dining_rounded,
          title: 'auth.delivery_login_title'.tr(),
          subtitle: 'auth.delivery_login_subtitle'.tr(),
          iconColor: Colors.white,
          bgColor: const Color(0xFF1565C0),
        ),
        const SizedBox(height: 28),

        _buildCard(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Champ téléphone
              _buildTextField(
                controller: _deliveryPhoneCtrl,
                label: 'auth.phone_number'.tr(),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),

              // Champ mot de passe
              TextField(
                controller: _deliveryPasswordCtrl,
                obscureText: !_deliveryPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'auth.password'.tr(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_deliveryPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() =>
                        _deliveryPasswordVisible = !_deliveryPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton connexion
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        final phone = _deliveryPhoneCtrl.text.trim();
                        final password = _deliveryPasswordCtrl.text;
                        if (phone.isEmpty || password.isEmpty) return;
                        context.read<AuthBloc>().add(
                              AuthEvent.loginDelivery(
                                phone: phone,
                                password: password,
                              ),
                            );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('auth.login_btn'.tr()),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.push('/auth/forgot-password'),
          child: Text('auth.forgot_password'.tr()),
        ),

        // Info box pour les livreurs
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF1565C0).withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: Color(0xFF1565C0), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'auth.delivery_info'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ─── OTP Form ─────────────────────────────────────────────────────────────

  Widget _buildOtpForm(
      BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(
          theme,
          icon: Icons.sms_outlined,
          title: 'auth.verify_otp_title'.tr(),
          subtitle: '${'auth.verify_instruction'.tr()} $_otpPhone',
          iconColor: Colors.white,
          bgColor: theme.colorScheme.primary,
        ),
        const SizedBox(height: 28),

        _buildCard(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // OTP input avec grand style
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                ),
                decoration: InputDecoration(
                  hintText: '------',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    fontSize: 32,
                    letterSpacing: 10,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: theme.colorScheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        context.read<AuthBloc>().add(AuthEvent.verifyOtp(
                              phone: _otpPhone!,
                              otp: _otpCtrl.text.trim(),
                            ));
                      },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('auth.verify_btn'.tr()),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _otpPhone = null),
                child: Text('common.back'.tr()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Register Form ────────────────────────────────────────────────────────

  Widget _buildRegisterForm(
      BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(
          theme,
          icon: Icons.person_add_rounded,
          title: 'auth.register_btn'.tr(),
          subtitle: 'auth.register_subtitle'.tr(),
          iconColor: Colors.white,
          bgColor: theme.colorScheme.primary,
        ),
        const SizedBox(height: 28),

        _buildCard(
          theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _regNameCtrl,
                label: 'auth.name'.tr(),
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _regEmailCtrl,
                label: 'auth.email'.tr(),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _regPasswordCtrl,
                obscureText: !_regPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'auth.password'.tr(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_regPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(
                        () => _regPasswordVisible = !_regPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _regCityCtrl,
                label: 'auth.city'.tr(),
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        context.read<AuthBloc>().add(AuthEvent.register(
                              name: _regNameCtrl.text.trim(),
                              email: _regEmailCtrl.text.trim(),
                              password: _regPasswordCtrl.text,
                              city: _regCityCtrl.text.trim(),
                            ));
                      },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('auth.register_btn'.tr()),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // CGU
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(text: 'auth.terms_prefix'.tr()),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () =>
                        launchUrl(Uri.parse('https://cliceat.cm/terms')),
                    child: Text(
                      'auth.terms_cgu'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: 'auth.terms_conjunction'.tr()),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () =>
                        launchUrl(Uri.parse('https://cliceat.cm/privacy')),
                    child: Text(
                      'auth.terms_privacy'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _showRegister = false),
          child: Text('auth.have_account'.tr()),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ─── Tabs email & phone ───────────────────────────────────────────────────

  Widget _buildEmailTab(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: _emailCtrl,
          label: 'auth.email'.tr(),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordCtrl,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelText: 'auth.password'.tr(),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_passwordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () =>
                  setState(() => _passwordVisible = !_passwordVisible),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  context.read<AuthBloc>().add(AuthEvent.loginWithEmail(
                        email: _emailCtrl.text.trim(),
                        password: _passwordCtrl.text,
                      ));
                },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text('auth.login_btn'.tr()),
        ),
      ],
    );
  }

  Widget _buildPhoneTab(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: _phoneCtrl,
          label: 'auth.phone_hint'.tr(),
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        const Spacer(),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  final phone = _phoneCtrl.text.trim();
                  if (phone.isEmpty) return;
                  context
                      .read<AuthBloc>()
                      .add(AuthEvent.sendOtp(phone: phone));
                },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text('auth.send_otp'.tr()),
        ),
      ],
    );
  }

  // ─── Reusable components ──────────────────────────────────────────────────

  Widget _buildHeader(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(icon, size: 36, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCard(ThemeData theme, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildOrDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
              child:
                  Divider(color: theme.dividerColor.withValues(alpha: 0.4))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'auth.or'.tr(),
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
              child:
                  Divider(color: theme.dividerColor.withValues(alpha: 0.4))),
        ],
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () => _handleGoogleSignIn(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side:
            BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.g_mobiledata, size: 26),
          const SizedBox(width: 8),
          Text('auth.continue_with_google'.tr()),
        ],
      ),
    );
  }
}

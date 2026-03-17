import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  final String mode; // 'client' or 'delivery'
  const LoginPage({super.key, required this.mode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
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

  // Register
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPasswordCtrl = TextEditingController();
  final _regCityCtrl = TextEditingController();

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
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) return; // user cancelled
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('auth.error_google'.tr())),
          );
        }
        return;
      }
      if (context.mounted) {
        context.read<AuthBloc>().add(AuthEvent.loginWithGoogle(token: idToken));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('auth.error_google'.tr())),
        );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('auth.error_apple'.tr())),
          );
        }
        return;
      }
      if (context.mounted) {
        context.read<AuthBloc>().add(AuthEvent.loginWithApple(token: idToken));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('auth.error_apple'.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_, __, ___) => _onAuthenticated(context),
          otpSent: (phone) => setState(() => _otpPhone = phone),
          emailVerificationRequired: (email) => context.go('/auth/verify-email?email=${Uri.encodeComponent(email)}'),
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.tr()),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
        return Scaffold(
          appBar: AppBar(
            title: Text('auth.login_title'.tr()),
            elevation: 0,
            leading: BackButton(onPressed: () => context.go('/onboarding')),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _showRegister
                      ? _buildRegisterForm(context, theme, isLoading)
                      : _otpPhone != null
                          ? _buildOtpForm(context, theme, isLoading)
                          : _buildLoginForm(context, theme, isLoading),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Icon(Icons.fastfood, size: 64, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'auth.email'.tr()),
            Tab(text: 'auth.phone_hint'.tr()),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEmailTab(context, isLoading),
              _buildPhoneTab(context, isLoading),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.push('/auth/forgot-password'),
          child: Text('auth.forgot_password'.tr()),
        ),
        TextButton(
          onPressed: () => setState(() => _showRegister = true),
          child: Text('auth.no_account'.tr()),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('ou', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ]),
        ),
        // Google Sign-In
        OutlinedButton.icon(
          onPressed: () => _handleGoogleSignIn(context),
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: const Text('Continuer avec Google'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        // Apple Sign-In — required by Apple when any third-party sign-in is present
        if (Platform.isIOS) ...[
          const SizedBox(height: 8),
          SignInWithAppleButton(
            onPressed: () => _handleAppleSignIn(context),
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailTab(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'auth.email'.tr(),
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordCtrl,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelText: 'auth.password'.tr(),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : () {
            HapticFeedback.mediumImpact();
            context.read<AuthBloc>().add(AuthEvent.loginWithEmail(
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
            ));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('auth.login_btn'.tr()),
        ),
      ],
    );
  }

  Widget _buildPhoneTab(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'auth.phone_hint'.tr(),
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : () {
            HapticFeedback.mediumImpact();
            final phone = _phoneCtrl.text.trim();
            if (phone.isEmpty) return;
            context.read<AuthBloc>().add(AuthEvent.sendOtp(phone: phone));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('auth.send_otp'.tr()),
        ),
      ],
    );
  }

  Widget _buildOtpForm(BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('auth.verify_otp_title'.tr(), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('${'auth.verify_instruction'.tr()} $_otpPhone', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
        TextField(
          controller: _otpCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          decoration: InputDecoration(
            hintText: 'auth.otp_hint'.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : () {
            HapticFeedback.mediumImpact();
            context.read<AuthBloc>().add(AuthEvent.verifyOtp(
              phone: _otpPhone!,
              otp: _otpCtrl.text.trim(),
            ));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('auth.verify_btn'.tr()),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _otpPhone = null),
          child: Text('common.back'.tr()),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, ThemeData theme, bool isLoading) {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text('auth.register_btn'.tr(), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        TextField(
          controller: _regNameCtrl,
          decoration: InputDecoration(
            labelText: 'auth.name'.tr(),
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _regEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'auth.email'.tr(),
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _regPasswordCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'auth.password'.tr(),
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _regCityCtrl,
          decoration: InputDecoration(
            labelText: 'auth.city'.tr(),
            prefixIcon: const Icon(Icons.location_city_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : () {
            HapticFeedback.mediumImpact();
            context.read<AuthBloc>().add(AuthEvent.register(
              name: _regNameCtrl.text.trim(),
              email: _regEmailCtrl.text.trim(),
              password: _regPasswordCtrl.text,
              city: _regCityCtrl.text.trim(),
            ));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('auth.register_btn'.tr()),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        // Terms of Service & Privacy Policy (required by App Store / Play Store)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                const TextSpan(text: "En vous inscrivant, vous acceptez nos "),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse('https://cliceat.cm/terms')),
                    child: Text(
                      "CGU",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: " et notre "),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse('https://cliceat.cm/privacy')),
                    child: Text(
                      "Politique de confidentialité",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: "."),
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
      ],
    );
  }
}

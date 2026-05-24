import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:logger/logger.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';

class LoginPage extends StatefulWidget {
  final String mode;
  const LoginPage({super.key, required this.mode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _passwordVisible = false;

  final _otpCtrl = TextEditingController();
  String? _otpPhone;

  final _deliveryPhoneCtrl = TextEditingController();
  final _deliveryPasswordCtrl = TextEditingController();
  bool _deliveryPasswordVisible = false;

  bool get _isDelivery => widget.mode == 'delivery';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _otpCtrl.dispose();
    _deliveryPhoneCtrl.dispose();
    _deliveryPasswordCtrl.dispose();
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
        getIt<Logger>().e("Google Sign In failed: idToken is null");
        if (context.mounted) _showError(context, 'auth.error_google'.tr());
        return;
      }
      
      if (context.mounted) {
        context.read<AuthBloc>().add(AuthEvent.loginWithGoogle(token: idToken));
      }
    } catch (e, stack) {
      getIt<Logger>().e("Google Sign In Error", error: e, stackTrace: stack);
      if (context.mounted) _showError(context, 'auth.error_google'.tr());
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
        getIt<Logger>().e("Apple Sign In failed: identityToken is null");
        if (context.mounted) _showError(context, 'auth.error_apple'.tr());
        return;
      }
      if (context.mounted) {
        context.read<AuthBloc>().add(AuthEvent.loginWithApple(token: idToken));
      }
    } catch (e, stack) {
      getIt<Logger>().e("Apple Sign In Error", error: e, stackTrace: stack);
      if (context.mounted) _showError(context, 'auth.error_apple'.tr());
    }
  }

  void _showError(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_, _, _) => _onAuthenticated(context),
          otpSent: (phone) => setState(() => _otpPhone = phone),
          emailVerificationRequired: (email) => context.go(
            '/auth/verify-email?email=${Uri.encodeComponent(email)}',
          ),
          error: (message) => _showError(context, message.tr()),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return Scaffold(
          backgroundColor: context.colors.bg,
          body: SafeArea(
            child: Column(
              children: [
                // Back button row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      _BackButton(onTap: () => context.go('/onboarding')),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: _otpPhone != null
                              ? _buildOtpForm(context, isLoading)
                              : _isDelivery
                              ? _buildDeliveryForm(context, isLoading)
                              : _buildClientForm(context, isLoading),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Client Login ──────────────────────────────────────────────────────────

  Widget _buildClientForm(BuildContext context, bool isLoading) {
    return Column(
      key: const ValueKey('client'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo + Title
        _CELogo(),
        const SizedBox(height: 28),
        Text(
          'auth.login_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'auth.login_subtitle'.tr(),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: context.colors.muted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        _buildEmailTab(context, isLoading),

        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => context.push('/auth/forgot-password'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'auth.forgot_password'.tr(),
                style: GoogleFonts.inter(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Text(' · ', style: GoogleFonts.inter(color: AppTheme.muted)),
            TextButton(
              onPressed: () => context.push('/auth/register?role=client'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'auth.no_account'.tr(),
                style: GoogleFonts.inter(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        _orDivider(),
        _googleButton(context),
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

  // ── Delivery Login ────────────────────────────────────────────────────────

  Widget _buildDeliveryForm(BuildContext context, bool isLoading) {
    return Column(
      key: const ValueKey('delivery'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CELogo(),
        const SizedBox(height: 28),
        Text(
          'auth.delivery_login_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'auth.delivery_login_subtitle'.tr(),
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
        ),
        const SizedBox(height: 32),
        _styledInput(
          controller: _deliveryPhoneCtrl,
          label: 'auth.phone_number'.tr(),
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _styledInput(
          controller: _deliveryPasswordCtrl,
          label: 'auth.password'.tr(),
          icon: Icons.lock_outline,
          obscureText: !_deliveryPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _deliveryPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => setState(
              () => _deliveryPasswordVisible = !_deliveryPasswordVisible,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _redButton(
          label: 'auth.login_btn'.tr(),
          isLoading: isLoading,
          onTap: () {
            HapticFeedback.mediumImpact();
            final phone = _deliveryPhoneCtrl.text.trim();
            final password = _deliveryPasswordCtrl.text;
            if (phone.isEmpty || password.isEmpty) return;
            context.read<AuthBloc>().add(
              AuthEvent.loginDelivery(phone: phone, password: password),
            );
          },
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.push('/auth/forgot-password'),
          child: Text(
            'auth.forgot_password'.tr(),
            style: GoogleFonts.inter(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => context.push('/auth/register?role=delivery'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.honeySoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.honey.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_add_outlined,
                  color: AppTheme.orange,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auth.become_driver_title'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.colors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'auth.become_driver_subtitle'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: context.colors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppTheme.muted,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── OTP Form ──────────────────────────────────────────────────────────────

  Widget _buildOtpForm(BuildContext context, bool isLoading) {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'Entre le code\nreçu par SMS',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
            children: [
              const TextSpan(text: 'Envoyé au '),
              TextSpan(
                text: _otpPhone,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: _otpCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 10,
            color: AppTheme.ink,
          ),
          decoration: InputDecoration(
            hintText: '· · · · · ·',
            hintStyle: GoogleFonts.inter(
              fontSize: 28,
              color: AppTheme.mutedLight,
              letterSpacing: 8,
            ),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.ink, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text.rich(
            TextSpan(
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
              children: [
                const TextSpan(text: 'Renvoyer le code dans '),
                TextSpan(
                  text: '0:42',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _redButton(
          label: 'auth.verify_btn'.tr(),
          isLoading: isLoading,
          onTap: () {
            HapticFeedback.mediumImpact();
            context.read<AuthBloc>().add(
              AuthEvent.verifyOtp(phone: _otpPhone!, otp: _otpCtrl.text.trim()),
            );
          },
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _otpPhone = null),
          child: Text(
            'Retour',
            style: GoogleFonts.inter(
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Tabs ──────────────────────────────────────────────────────────────────

  Widget _buildEmailTab(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _styledInput(
          controller: _emailCtrl,
          label: 'auth.email'.tr(),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _styledInput(
          controller: _passwordCtrl,
          label: 'auth.password'.tr(),
          icon: Icons.lock_outline,
          obscureText: !_passwordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        const SizedBox(height: 14),
        _redButton(
          label: 'auth.login_btn'.tr(),
          isLoading: isLoading,
          onTap: () {
            HapticFeedback.mediumImpact();
            context.read<AuthBloc>().add(
              AuthEvent.loginWithEmail(
                email: _emailCtrl.text.trim(),
                password: _passwordCtrl.text,
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Reusable helpers ──────────────────────────────────────────────────────

  Widget _styledInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.inkSoft, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
        prefixIcon: Icon(icon, color: AppTheme.muted, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.ink, width: 2),
        ),
      ),
    );
  }

  Widget _redButton({
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppTheme.lineSoft)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'ou',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
            ),
          ),
          Expanded(child: Divider(color: AppTheme.lineSoft)),
        ],
      ),
    );
  }

  Widget _googleButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleGoogleSignIn(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppTheme.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.g_mobiledata, size: 26, color: AppTheme.ink),
          const SizedBox(width: 8),
          Text(
            'auth.continue_with_google'.tr(),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.line),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppTheme.ink,
        ),
      ),
    );
  }
}

class _CELogo extends StatelessWidget {
  const _CELogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}

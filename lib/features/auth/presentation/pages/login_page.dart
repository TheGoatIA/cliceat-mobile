<<<<<<< HEAD
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
=======
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

  @override
  State<LoginPage> createState() => _LoginPageState();
}

<<<<<<< HEAD
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
      final account = await GoogleSignIn.instance.authenticate();
      final auth = account.authentication;
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
=======
class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isEmailMode = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isEmailMode) {
        context.read<AuthBloc>().add(AuthEvent.loginWithEmail(
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim(),
        ));
      } else {
        context.read<AuthBloc>().add(AuthEvent.sendOtp(phone: _phoneController.text.trim()));
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
      }
    }
  }

<<<<<<< HEAD
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
          authenticated: (_, _, _) => _onAuthenticated(context),
          otpSent: (phone) => setState(() => _otpPhone = phone),
          emailVerificationRequired: (email) => context.go('/auth/verify-email?email=${Uri.encodeComponent(email)}'),
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.tr()),
                backgroundColor: theme.colorScheme.error,
              ),
            );
=======
  void _loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      if (!mounted) return;
      if (googleAuth.idToken != null) {
        context.read<AuthBloc>().add(AuthEvent.loginWithGoogle(token: googleAuth.idToken!));
      }
    } catch (e) {
      debugPrint('Google Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de la connexion Google.')));
    }
  }

  void _loginWithApple() async {
     try {
       final credential = await SignInWithApple.getAppleIDCredential(
         scopes: [
           AppleIDAuthorizationScopes.email,
           AppleIDAuthorizationScopes.fullName,
         ],
       );
       if (!mounted) return;
       if (credential.identityToken != null) {
         context.read<AuthBloc>().add(AuthEvent.loginWithApple(token: credential.identityToken!));
       }
     } catch (e) {
       debugPrint('Apple Error: $e');
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de la connexion Apple.')));
     }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          otpSent: (phone) {
            context.push('/otp', extra: phone);
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
<<<<<<< HEAD
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
=======
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(title: Text('auth.login_title'.tr())),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isEmailMode ? 'Connexion Email' : 'auth.login_phone_title'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isEmailMode ? 'Saisissez vos identifiants pour continuer' : 'auth.login_subtitle'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  if (_isEmailMode) ...[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Email invalide' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Mot de passe requis' : null,
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'auth.phone_hint'.tr(),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'auth.phone_error'.tr();
                        }
                        return null;
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'common.continue_btn'.tr(),
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _isEmailMode = !_isEmailMode),
                    child: Text(_isEmailMode ? 'Se connecter plutôt avec un numéro' : 'Se connecter par Email'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.5))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("OU", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.5))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata, size: 32),
                    label: const Text('Connecter avec Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _loginWithGoogle,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.apple, size: 28),
                    label: const Text('Connecter avec Apple'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _loginWithApple,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('Créer un compte (Client ou Livreur)'),
                  ),
                ],
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              ),
            ),
          ),
        );
      },
    );
  }
<<<<<<< HEAD

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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('auth.or'.tr(), style: const TextStyle(color: Colors.grey)),
            ),
            const Expanded(child: Divider()),
          ]),
        ),
        // Google Sign-In
        OutlinedButton.icon(
          onPressed: () => _handleGoogleSignIn(context),
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: Text('auth.continue_with_google'.tr()),
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
                TextSpan(text: 'auth.terms_prefix'.tr()),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse('https://cliceat.cm/terms')),
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
                    onTap: () => launchUrl(Uri.parse('https://cliceat.cm/privacy')),
                    child: Text(
                      'auth.terms_privacy'.tr(),
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
=======
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
}

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

  @override
  State<LoginPage> createState() => _LoginPageState();
}

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
      }
    }
  }

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
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
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
              ),
            ),
          ),
        );
      },
    );
  }
}

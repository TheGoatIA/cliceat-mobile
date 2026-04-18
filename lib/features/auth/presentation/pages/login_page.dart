import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  final String? mode;
  const LoginPage({super.key, this.mode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  bool get _isDelivery => widget.mode == 'deliveryman';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppTheme.errorColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          otpSent: (phone) => context.go('/otp', extra: phone),
          authenticated: (_, __, mode) {
            if (mode == 'deliveryman') {
              context.go('/delivery');
            } else {
              context.go('/client');
            }
          },
          error: (msg) => _showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state is _Loading;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => context.go('/onboarding'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.fastfood_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Text('ClicEat',
                          style: theme.textTheme.displaySmall),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    _isDelivery
                        ? 'Espace Livreur'
                        : 'Connexion',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Heureux de vous revoir 👋',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_isDelivery)
                    _DeliveryLoginForm(
                        emailCtrl: _emailCtrl,
                        passCtrl: _passCtrl,
                        obscure: _obscure,
                        onToggleObscure: () =>
                            setState(() => _obscure = !_obscure),
                        isLoading: isLoading,
                        onSubmit: () {
                          if (_emailCtrl.text.trim().isNotEmpty &&
                              _passCtrl.text.isNotEmpty) {
                            context.read<AuthBloc>().add(
                                  AuthEvent.loginWithEmail(
                                    email: _emailCtrl.text.trim(),
                                    password: _passCtrl.text,
                                  ),
                                );
                          }
                        })
                  else
                    Column(
                      children: [
                        _buildTabBar(theme),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 190,
                          child: TabBarView(
                            controller: _tabs,
                            children: [
                              _PhoneForm(
                                ctrl: _phoneCtrl,
                                isLoading: isLoading,
                                onSubmit: () {
                                  final p = _phoneCtrl.text.trim();
                                  if (p.isNotEmpty) {
                                    context.read<AuthBloc>().add(
                                        AuthEvent.sendOtp(phone: p));
                                  }
                                },
                              ),
                              _EmailForm(
                                emailCtrl: _emailCtrl,
                                passCtrl: _passCtrl,
                                obscure: _obscure,
                                onToggle: () =>
                                    setState(() => _obscure = !_obscure),
                                isLoading: isLoading,
                                onSubmit: () {
                                  if (_emailCtrl.text.trim().isNotEmpty &&
                                      _passCtrl.text.isNotEmpty) {
                                    context.read<AuthBloc>().add(
                                          AuthEvent.loginWithEmail(
                                            email:
                                                _emailCtrl.text.trim(),
                                            password: _passCtrl.text,
                                          ),
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDivider(theme),
                        const SizedBox(height: 20),
                        _buildGoogleButton(theme, isLoading),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Pas encore de compte ?',
                                style: theme.textTheme.bodyMedium),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "S'inscrire",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: TabBar(
        controller: _tabs,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.55),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Téléphone'),
          Tab(text: 'Email'),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('ou continuer avec',
              style: theme.textTheme.bodySmall),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleButton(ThemeData theme, bool isLoading) {
    return OutlinedButton(
      onPressed: isLoading ? null : () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.g_mobiledata_rounded, size: 24),
          const SizedBox(width: 8),
          Text('Continuer avec Google',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PhoneForm extends StatelessWidget {
  final TextEditingController ctrl;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _PhoneForm({
    required this.ctrl,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '6XXXXXXXX',
            prefixIcon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('+237',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.white)),
                )
              : const Text('Envoyer le code OTP'),
        ),
      ],
    );
  }
}

class _EmailForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final VoidCallback onToggle;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _EmailForm({
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.onToggle,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passCtrl,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
              onPressed: onToggle,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.white)),
                )
              : const Text('Se connecter'),
        ),
      ],
    );
  }
}

class _DeliveryLoginForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _DeliveryLoginForm({
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.delivery_dining_rounded,
                  color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 12),
              Text(
                'Connectez-vous avec vos\ncredentials livreur',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passCtrl,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
              onPressed: onToggleObscure,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.white)),
                )
              : const Text('Connexion Livreur'),
        ),
      ],
    );
  }
}

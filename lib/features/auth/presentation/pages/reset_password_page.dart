import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          resetPasswordSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('auth.reset_password_success'.tr())),
            );
            context.go('/auth/login?mode=client');
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.tr()), backgroundColor: theme.colorScheme.error),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
        return Scaffold(
          appBar: AppBar(title: Text('auth.reset_password_title'.tr()), elevation: 0),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Icon(Icons.lock_outline, size: 72, color: theme.colorScheme.primary),
                    const SizedBox(height: 24),
                    Text(
                      'auth.reset_password_title'.tr(),
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'auth.new_password'.tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmCtrl,
                      obscureText: !_confirmVisible,
                      decoration: InputDecoration(
                        labelText: 'auth.confirm_password'.tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_confirmVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : () {
                        final password = _passwordCtrl.text;
                        final confirm = _confirmCtrl.text;
                        if (password.isEmpty || confirm.isEmpty) return;
                        if (password != confirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('auth.password_mismatch'.tr()), backgroundColor: theme.colorScheme.error),
                          );
                          return;
                        }
                        if (password.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('auth.password_too_short'.tr()), backgroundColor: theme.colorScheme.error),
                          );
                          return;
                        }
                        context.read<AuthBloc>().add(AuthEvent.resetPassword(token: widget.token, newPassword: password));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('auth.reset_password_btn'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

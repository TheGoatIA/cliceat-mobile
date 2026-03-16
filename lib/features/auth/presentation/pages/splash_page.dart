import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Just a tiny minimum delay for branding
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      // After delay, trigger AuthBloc check logic natively through event or just let 
      // the BlockListener do its job if state is already loaded. 
      // If it's still initial, it'll trigger later.
      final state = context.read<AuthBloc>().state;
      state.whenOrNull(
        authenticated: (token, userId, currentMode) {
          if (currentMode == 'delivery') {
            context.go('/delivery');
          } else {
            context.go('/client');
          }
        },
        unauthenticated: () {
          context.go('/onboarding');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (token, userId, currentMode) {
            if (currentMode == 'delivery') {
              context.go('/delivery');
            } else {
              context.go('/client');
            }
          },
          unauthenticated: () {
            context.go('/onboarding');
          },
        );
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary, // ClicEat Red
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation / Icône de lancement
            Icon(Icons.fastfood, size: 80, color: theme.colorScheme.onPrimary),
            const SizedBox(height: 20),
            Text(
              'splash_title'.tr(),
              style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

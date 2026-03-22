import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD
=======
import 'package:easy_localization/easy_localization.dart';
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
import '../bloc/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
          authenticated: (token, userId, currentMode) {
            if (currentMode == 'delivery') {
              context.go('/delivery');
            } else {
              context.go('/client');
            }
          },
<<<<<<< HEAD
          unauthenticated: () => context.go('/onboarding'),
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fastfood, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'ClicEat',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
        ),
      ),
    ),
    );
  }
}

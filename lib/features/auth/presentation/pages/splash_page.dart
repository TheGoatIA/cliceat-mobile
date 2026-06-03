import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _motoAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _motoAnimation = Tween<double>(begin: -100, end: 400).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (token, userId, currentMode) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (!context.mounted) return;
              if (currentMode == 'delivery') {
                context.go('/delivery');
              } else {
                context.go('/client');
              }
            });
          },
          unauthenticated: () {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (!context.mounted) return;
              context.go('/onboarding');
            });
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryRed,
        body: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Real Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 140,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('C', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryRed)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ClicEat',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'EXCELLENCE DANS VOTRE ASSIETTE',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),

            // Delivery Animation at the bottom
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: AnimatedBuilder(
                      animation: _motoAnimation,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Positioned(
                              left: _motoAnimation.value,
                              child: const Icon(
                                Icons.delivery_dining_rounded,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 10,
                              child: Icon(
                                Icons.person_pin_circle_rounded,
                                size: 32,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

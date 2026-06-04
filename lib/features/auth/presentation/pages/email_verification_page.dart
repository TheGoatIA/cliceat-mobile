import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../../../../../core/theme/app_theme.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  const EmailVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          emailVerified: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('auth.email_verified_success'.tr()),
                backgroundColor: AppTheme.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
            context.go('/auth/login?mode=client');
          },
          emailVerificationRequired: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('auth.verification_email_resent'.tr()),
                backgroundColor: AppTheme.ink,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.tr()),
                backgroundColor: AppTheme.primaryRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading =
            state.maybeWhen(loading: () => true, orElse: () => false);
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: GestureDetector(
                    onTap: () => context.go('/auth/login?mode=client'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.line),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: AppTheme.ink),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.redSoft,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.mark_email_unread_outlined,
                                size: 40,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'auth.verify_email_title'.tr(),
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.ink,
                                letterSpacing: -0.8,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'auth.verify_email_instruction'.tr(args: [email]),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.muted,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              email,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.read<AuthBloc>().add(
                                            AuthEvent.resendVerificationEmail(
                                                email: email));
                                      },
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : const Icon(Icons.refresh_rounded,
                                        size: 18),
                                label: Text(
                                  'auth.resend_verification'.tr(),
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryRed,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () =>
                                  context.go('/auth/login?mode=client'),
                              child: Text(
                                'auth.back_to_login'.tr(),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.muted,
                                ),
                              ),
                            ),
                          ],
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
}

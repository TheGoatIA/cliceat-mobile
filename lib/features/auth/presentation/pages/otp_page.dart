import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent.verifyOtp(phone: widget.phone, otp: _otpController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (token, userId, currentMode) => context.go('/onboarding'),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.line),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.ink),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Entre le code\nreçu par SMS',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 30, fontWeight: FontWeight.w700,
                                  color: AppTheme.ink, letterSpacing: -0.8, height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
                                  children: [
                                    const TextSpan(text: 'Envoyé au '),
                                    TextSpan(
                                      text: widget.phone,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.ink),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 6,
                                style: GoogleFonts.inter(
                                  fontSize: 28, fontWeight: FontWeight.w700,
                                  letterSpacing: 10, color: AppTheme.ink,
                                ),
                                decoration: InputDecoration(
                                  hintText: '· · · · · ·',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 28, color: AppTheme.mutedLight, letterSpacing: 8,
                                  ),
                                  counterText: '',
                                  filled: true, fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.line)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.line)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.ink, width: 2)),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 4) return 'auth.otp_error'.tr();
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Text.rich(TextSpan(
                                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
                                  children: [
                                    const TextSpan(text: 'Renvoyer dans '),
                                    TextSpan(
                                      text: '0:42',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppTheme.primaryRed),
                                    ),
                                  ],
                                )),
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryRed,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : Text('auth.verify_btn'.tr(), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
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

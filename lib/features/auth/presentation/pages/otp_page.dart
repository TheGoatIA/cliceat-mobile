import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown == 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _otp => _ctrls.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    if (_otp.length == 6) {
      _verify();
    }
  }

  void _verify() {
    context.read<AuthBloc>().add(
          AuthEvent.verifyOtp(phone: widget.phone, otp: _otp),
        );
  }

  void _resend() {
    context
        .read<AuthBloc>()
        .add(AuthEvent.sendOtp(phone: widget.phone));
    _startTimer();
    for (final c in _ctrls) {
      c.clear();
    }
    _nodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_, __, mode) {
            if (mode == 'deliveryman') {
              context.go('/delivery');
            } else {
              context.go('/client');
            }
          },
          error: (msg) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(msg),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ));
            for (final c in _ctrls) {
              c.clear();
            }
            _nodes[0].requestFocus();
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state is _Loading;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => context.go('/login'),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.sms_outlined,
                        color: theme.colorScheme.primary, size: 30),
                  ),
                  const SizedBox(height: 24),
                  Text('Vérification OTP',
                      style: theme.textTheme.displaySmall),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      children: [
                        const TextSpan(
                            text:
                                'Code envoyé par SMS au numéro\n'),
                        TextSpan(
                          text: '+237 ${widget.phone}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 46,
                        height: 56,
                        child: TextField(
                          controller: _ctrls[i],
                          focusNode: _nodes[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: isLoading
                                ? Colors.grey.shade100
                                : theme.colorScheme.surface,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2),
                            ),
                          ),
                          onChanged: (v) => _onChanged(i, v),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...
                    [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _otp.length == 6 ? _verify : null,
                          child: const Text('Vérifier'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: _countdown > 0
                            ? Text(
                                'Renvoyer dans $_countdown secondes',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              )
                            : TextButton(
                                onPressed: _resend,
                                child: const Text('Renvoyer le code'),
                              ),
                      ),
                    ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

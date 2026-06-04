import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../../../../../core/mixins/secure_screen_mixin.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';
import '../../../../../core/services/analytics_service.dart';

class PaymentWebviewPage extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  /// Si true, après vérification du paiement, on navigue vers le wallet
  /// et non vers la page de succès de commande.
  final bool isWalletRecharge;

  const PaymentWebviewPage({
    super.key,
    required this.paymentUrl,
    required this.orderId,
    this.isWalletRecharge = false,
  });

  @override
  State<PaymentWebviewPage> createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends State<PaymentWebviewPage>
    with SecureScreenMixin {
  late final WebViewController _controller;
  bool _loading = true;
  bool _verifying = false;
  bool _paymentFailed = false;

  /// Polling pour les paiements mobiles (Orange Money, MTN, etc.)
  /// qui ne redirigent pas toujours vers l'URL de succès.
  Timer? _pollingTimer;
  int _pollCount = 0;
  static const int _maxPollAttempts = 20; // 20 x 3s = 60s max
  static const Duration _pollInterval = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
          onNavigationRequest: (request) {
            final url = request.url.toLowerCase();

            if (url.startsWith('cliceat://payment/success')) {
              _startVerificationWithPolling();
              return NavigationDecision.prevent;
            }
            if (url.startsWith('cliceat://payment/cancel') ||
                url.startsWith('cliceat://payment/failed')) {
              _cancelPolling();
              context.pop();
              return NavigationDecision.prevent;
            }

            if (url.contains('/payment/success') ||
                url.contains('payment_success') ||
                url.contains('status=success') ||
                url.contains('notchpay.co/pay/success')) {
              _startVerificationWithPolling();
              return NavigationDecision.prevent;
            }
            if (url.contains('/payment/cancel') ||
                url.contains('payment_cancel') ||
                url.contains('status=cancel') ||
                url.contains('status=failed')) {
              _cancelPolling();
              context.pop();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    getIt<AnalyticsService>().logPaymentInitiated(widget.orderId, 'notchpay');
  }

  @override
  void dispose() {
    _cancelPolling();
    super.dispose();
  }

  void _cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _pollCount = 0;
  }

  /// Lance la vérification immédiatement, puis passe en polling
  /// si le statut est encore "initiated" (paiement mobile en cours de traitement).
  void _startVerificationWithPolling() {
    if (_verifying) return;
    setState(() => _verifying = true);
    _pollCount = 0;
    _attemptVerification();
  }

  Future<void> _attemptVerification() async {
    try {
      final result =
          await getIt<OrderRepository>().verifyPayment(widget.orderId);
      if (!mounted) return;

      result.fold(
        (err) {
          // Erreur réseau / serveur → on réessaie si on n'a pas atteint le max
          _pollCount++;
          if (_pollCount < _maxPollAttempts) {
            _pollingTimer = Timer(_pollInterval, _attemptVerification);
          } else {
            setState(() => _verifying = false);
            _showPaymentFailed();
          }
        },
        (isSuccess) {
          if (isSuccess) {
            _cancelPolling();
            _onPaymentSuccess();
          } else {
            // Statut non encore "completed" (ex: initiated, pending) → polling
            _pollCount++;
            if (_pollCount < _maxPollAttempts) {
              _pollingTimer = Timer(_pollInterval, _attemptVerification);
            } else {
              setState(() => _verifying = false);
              _showPaymentFailed();
            }
          }
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() => _verifying = false);
        _showPaymentFailed();
      }
    }
  }

  void _onPaymentSuccess() {
    if (!mounted) return;
    if (widget.isWalletRecharge) {
      // Rechargement wallet : rafraîchir le profil (pour le solde) puis revenir au wallet
      context.read<ProfileCubit>().loadProfile();
      context.go('/client/wallet');
    } else {
      // Paiement commande : page de succès
      context.go('/client/order-success/${widget.orderId}');
    }
  }

  void _showPaymentFailed() {
    setState(() => _paymentFailed = true);
  }

  void _retryPayment() {
    setState(() {
      _paymentFailed = false;
      _loading = true;
    });
    _cancelPolling();
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'payment.title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.ink),
          onPressed: () => _showCancelDialog(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading || _verifying)
            Container(
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                        color: AppTheme.primaryRed, strokeWidth: 2),
                    if (_verifying) ...[
                      const SizedBox(height: 16),
                      Text(
                        _pollCount > 0
                            ? 'payment.verifying'.tr()
                            : 'common.loading'.tr(),
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 14),
                      ),
                      if (_pollCount > 0) ...[
                        const SizedBox(height: 6),
                        Text(
                          'payment.waiting_confirmation'.tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          if (_paymentFailed)
            Container(
              color: Colors.black87,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(Icons.error_outline,
                            color: AppTheme.primaryRed, size: 40),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'payment.failed_title'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'payment.failed_message'.tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 14),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _retryPayment,
                          icon: const Icon(Icons.replay, size: 18),
                          label: Text('payment.retry_payment'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.5)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            'common.cancel'.tr(),
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'payment.cancel_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.ink),
        ),
        content: Text(
          'payment.cancel_message'.tr(),
          style:
              GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.no'.tr(),
                style: GoogleFonts.inter(color: AppTheme.muted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelPolling();
              context.pop();
            },
            child: Text(
              'common.yes'.tr(),
              style: GoogleFonts.inter(
                  color: AppTheme.primaryRed, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

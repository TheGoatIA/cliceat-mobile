import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cliceat_app/core/di/injection.dart';
import '../../../../../core/mixins/secure_screen_mixin.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';

class PaymentWebviewPage extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebviewPage({
    super.key,
    required this.paymentUrl,
    required this.orderId,
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

            // Primary: deep-link scheme set by backend/NotchPay
            if (url.startsWith('cliceat://payment/success')) {
              _verifyPaymentThenNavigate();
              return NavigationDecision.prevent;
            }
            if (url.startsWith('cliceat://payment/cancel') ||
                url.startsWith('cliceat://payment/failed')) {
              context.pop();
              return NavigationDecision.prevent;
            }

            // Fallback: HTTPS return URL patterns from NotchPay
            if (url.contains('/payment/success') ||
                url.contains('payment_success') ||
                url.contains('status=success') ||
                url.contains('notchpay.co/pay/success')) {
              _verifyPaymentThenNavigate();
              return NavigationDecision.prevent;
            }
            if (url.contains('/payment/cancel') ||
                url.contains('payment_cancel') ||
                url.contains('status=cancel') ||
                url.contains('status=failed')) {
              context.pop();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Verify with backend that payment actually succeeded before showing success.
  Future<void> _verifyPaymentThenNavigate() async {
    if (_verifying) return;
    setState(() => _verifying = true);
    try {
      final result =
          await getIt<OrderRepository>().verifyPayment(widget.orderId);
      if (!mounted) return;
      result.fold(
        (_) {
          setState(() => _verifying = false);
          _showPaymentFailed();
        },
        (isSuccess) {
          if (isSuccess) {
            context.go('/client/order-success/${widget.orderId}');
          } else {
            setState(() => _verifying = false);
            _showPaymentFailed();
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

  void _showPaymentFailed() {
    setState(() => _paymentFailed = true);
  }

  void _retryPayment() {
    setState(() {
      _paymentFailed = false;
      _loading = true;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showCancelDialog(context),
        ),
        elevation: 0,
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
                    const CircularProgressIndicator(),
                    if (_verifying) ...[
                      const SizedBox(height: 16),
                      Text(
                        'common.loading'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
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
                      Icon(Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'payment.failed_title'.tr(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'payment.failed_message'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _retryPayment,
                        icon: const Icon(Icons.replay),
                        label: Text('payment.retry_payment'.tr()),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text('common.cancel'.tr()),
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
        title: Text('payment.cancel_title'.tr()),
        content: Text('payment.cancel_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.no'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: Text(
              'common.yes'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

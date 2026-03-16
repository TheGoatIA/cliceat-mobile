import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;
  
  const PaymentWebViewPage({super.key, required this.paymentUrl});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // We can check if the URL contains a success or failure callback from our backend/NotchPay
            if (url.contains('/payment/success')) {
              _handlePaymentSuccess();
            } else if (url.contains('/payment/cancel') || url.contains('/payment/failed')) {
              _handlePaymentFailure();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Validate if we should allow navigation
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentSuccess() {
    // Navigate to order-success page. In a real scenario, this gets the orderId.
    context.go('/order-success', extra: 'CMD-NOTCH-999'); 
  }

  void _handlePaymentFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('payment.failed'.tr())),
    );
    context.pop(); // Go back to checkout on failure
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(), // Cancel payment
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

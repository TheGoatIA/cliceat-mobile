import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../shared/widgets/primary_button.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  const OrderSuccessPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // MOCK Lottie size
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, size: 100, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 32),
              Text(
                'checkout.success_title'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'checkout.success_desc'.tr(args: [orderId]),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Suivre ma commande',
                onPressed: () {
                  context.go('/client/tracking/$orderId');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/client'),
                child: Text('checkout.back_home'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

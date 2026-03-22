import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
<<<<<<< HEAD

class OrderSuccessPage extends StatelessWidget {
  final String orderId;

=======
import '../../../../../shared/widgets/primary_button.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
  const OrderSuccessPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = Theme.of(context);
=======
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
<<<<<<< HEAD
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 100, color: Colors.green),
              ),
              const SizedBox(height: 32),
              Text(
                'order.success_title'.tr(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
<<<<<<< HEAD
                'order.success_message'.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'order.order_id'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderId.length > 12 ? orderId.substring(orderId.length - 12) : orderId,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'order.estimated_delivery'.tr(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/client/tracking/$orderId'),
                  icon: const Icon(Icons.location_on),
                  label: Text('order.track_order'.tr()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/client'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('order.back_to_home'.tr()),
                ),
=======
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
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              ),
            ],
          ),
        ),
      ),
    );
  }
}

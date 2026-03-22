import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfirmPickupPage extends StatelessWidget {
  const ConfirmPickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('delivery.confirm_pickup_title'.tr(args: ['10842'])),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mets Traditionnels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('delivery.verify_items'.tr()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('delivery.items_count'.tr(args: ['3']), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.check_box_outline_blank),
                        title: Text('1x Ndolé Viande avec Miondo'),
                        subtitle: Text('Sans piment'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.check_box_outline_blank),
                        title: Text('2x Jus de fruit de la passion'),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.call),
                        label: Text('common.call_restaurant'.tr()),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.warning_amber),
                        label: Text('common.report_issue'.tr()),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Dismissible(
                  key: const Key('pickup_slider'),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) {
                    HapticFeedback.heavyImpact();
                    // Navigate to DropOff navigation (phase 2)
                    context.push('/delivery/dropoff');
                  },
                  background: Container(
                     decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(30)),
                     alignment: Alignment.centerLeft,
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: const Icon(Icons.check, color: Colors.white, size: 32),
                  ),
                  child: Container(
                     width: double.infinity,
                     height: 60,
                     decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.primary,
                       borderRadius: BorderRadius.circular(30),
                     ),
                     child: Stack(
                       children: [
                         Positioned(
                           left: 5, top: 4, bottom: 4,
                           child: Container(
                             width: 52,
                             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                             child: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary),
                           ),
                         ),
                         Center(
                           child: Text('delivery.confirm_pickup'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                         )
                       ],
                     ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

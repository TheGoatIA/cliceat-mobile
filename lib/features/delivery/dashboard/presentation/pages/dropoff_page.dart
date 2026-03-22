import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class DropoffPage extends StatelessWidget {
  const DropoffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livraison Client'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.person_pin_circle, size: 48, color: Colors.green),
                      SizedBox(height: 12),
                      Text('Boris Gautier', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Akwa (Proche ancienne direction)'),
                      SizedBox(height: 12),
                      Text('Instructions: "Bâtiment blanc au 2ème étage, sonnez à la porte 4"', style: TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                     Expanded(
                       child: ElevatedButton.icon(
                         style: ElevatedButton.styleFrom(
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           backgroundColor: Theme.of(context).colorScheme.primary,
                           foregroundColor: Colors.white,
                         ),
                         icon: const Icon(Icons.call),
                         label: const Text('Appeler Client'),
                         onPressed: () {
                           HapticFeedback.lightImpact();
                         },
                       ),
                     ),
                     const SizedBox(width: 16),
                     Expanded(
                       child: ElevatedButton.icon(
                         style: ElevatedButton.styleFrom(
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           backgroundColor: Theme.of(context).colorScheme.secondary,
                           foregroundColor: Colors.white,
                         ),
                         icon: const Icon(Icons.chat),
                         label: const Text('Message'),
                         onPressed: () {
                           HapticFeedback.lightImpact();
                         },
                       ),
                     ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Paiement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.money, color: Colors.green, size: 32),
                  title: const Text('Cash à récolter'),
                  trailing: const Text('10 500 FCFA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                const SizedBox(height: 32),
                Dismissible(
                  key: const Key('dropoff_slider'),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) {
                    HapticFeedback.heavyImpact();
                    // Delivery is finished, return to dashboard
                    // Pop all the way to dashboard
                    context.go('/delivery');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Livraison terminée avec succès ! +1 500 FCFA'),
                        backgroundColor: Colors.green.shade700,
                      ),
                    );
                  },
                  background: Container(
                     decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                     alignment: Alignment.centerLeft,
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: const Icon(Icons.check, color: Colors.white, size: 32),
                  ),
                  child: Container(
                     width: double.infinity,
                     height: 60,
                     decoration: BoxDecoration(
                       color: Colors.green,
                       borderRadius: BorderRadius.circular(30),
                     ),
                     child: Stack(
                       children: [
                         Positioned(
                           left: 5, top: 4, bottom: 4,
                           child: Container(
                             width: 52,
                             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                             child: const Icon(Icons.arrow_forward_ios, color: Colors.green),
                           ),
                         ),
                         const Center(
                           child: Text('Confirmer la Livraison', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                         )
                       ],
                     ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

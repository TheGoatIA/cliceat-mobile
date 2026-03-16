import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasources/order_service.dart';

class OrderRatingPage extends StatefulWidget {
  final String orderId;
  const OrderRatingPage({super.key, required this.orderId});

  @override
  State<OrderRatingPage> createState() => _OrderRatingPageState();
}

class _OrderRatingPageState extends State<OrderRatingPage> {
  int _restaurantRating = 0;
  int _deliveryRating = 0;
  final TextEditingController _commentController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Évaluer la commande'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/client'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                Text(
                  'Commande livrée !',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Comment s\'est passée votre expérience ?', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                
                const SizedBox(height: 48),
                _buildRatingSection(
                  context,
                  title: 'Le Restaurant',
                  subtitle: 'Qualité du repas, emballage',
                  currentRating: _restaurantRating,
                  onRatingChanged: (rating) {
                    HapticFeedback.selectionClick();
                    setState(() => _restaurantRating = rating);
                  },
                ),
                
                const Divider(height: 48),
                
                _buildRatingSection(
                  context,
                  title: 'Le Livreur',
                  subtitle: 'Rapidité, courtoisie',
                  currentRating: _deliveryRating,
                  onRatingChanged: (rating) {
                    HapticFeedback.selectionClick();
                    setState(() => _deliveryRating = rating);
                  },
                ),

                const SizedBox(height: 32),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Un commentaire ? (Optionnel)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 48),
                PrimaryButton(
                  text: 'Envoyer l\'évaluation',
                  isLoading: _isLoading,
                  onPressed: (_restaurantRating > 0 && _deliveryRating > 0) ? () async {
                    HapticFeedback.mediumImpact();
                    setState(() => _isLoading = true);
                    try {
                      await getIt<OrderService>().rateOrder(
                        widget.orderId,
                        {
                          'restaurantRating': _restaurantRating,
                          'deliveryRating': _deliveryRating,
                          'comment': _commentController.text,
                        },
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Merci pour votre retour !')));
                        context.go('/client');
                      }
                    } catch (e) {
                      debugPrint('Error rating order: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur réseau. Veuillez réessayer.')));
                      }
                    } finally {
                      if (context.mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  } : () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context, {required String title, required String subtitle, required int currentRating, required Function(int) onRatingChanged}) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              iconSize: 40,
              icon: Icon(
                index < currentRating ? Icons.star : Icons.star_border,
                color: index < currentRating ? Colors.amber : Theme.of(context).dividerColor,
              ),
              onPressed: () => onRatingChanged(index + 1),
            );
          }),
        ),
      ],
    );
  }
}

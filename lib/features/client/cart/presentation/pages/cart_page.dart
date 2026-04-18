import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cart_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/coupon_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _couponCtrl = TextEditingController();
  bool _validatingCoupon = false;

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  Future<void> _validateCoupon(BuildContext context) async {
    final code = _couponCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() => _validatingCoupon = true);
    try {
      final resp =
          await getIt<CouponService>().validateCoupon(code);
      if (resp.isSuccessful && context.mounted) {
        final data = resp.body as Map<String, dynamic>;
        final discount = ((data['discount'] as num?) ?? 0).toDouble();
        context.read<CartBloc>().add(ApplyCoupon(code, discount));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon appliqué: -${discount.toStringAsFixed(0)} XAF'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coupon invalide ou expiré'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur de validation du coupon')),
        );
      }
    } finally {
      setState(() => _validatingCoupon = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cart) {
        if (cart.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Mon panier')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80,
                      color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('Votre panier est vide',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => context.go('/client'),
                    child: const Text('Parcourir les restaurants'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mon panier'),
            actions: [
              TextButton(
                onPressed: () =>
                    context.read<CartBloc>().add(ClearCart()),
                child: Text('Vider',
                    style:
                        TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Items
              ...cart.items.map((item) => Card(
                    child: ListTile(
                      title: Text(item.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(
                          '${item.price.toStringAsFixed(0)} XAF × ${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () =>
                                context.read<CartBloc>().add(
                                      UpdateQuantity(
                                          item.itemId,
                                          item.quantity - 1),
                                    ),
                          ),
                          Text('${item.quantity}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () =>
                                context.read<CartBloc>().add(
                                      UpdateQuantity(
                                          item.itemId,
                                          item.quantity + 1),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 16),

              // Coupon
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Code promo',
                            prefixIcon: Icon(Icons.discount),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _validatingCoupon
                            ? null
                            : () => _validateCoupon(context),
                        child: _validatingCoupon
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                              )
                            : const Text('Appliquer'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _SummaryRow(
                          label: 'Sous-total',
                          value:
                              '${cart.subtotal.toStringAsFixed(0)} XAF'),
                      _SummaryRow(
                          label: 'Livraison',
                          value:
                              '${cart.deliveryFee.toStringAsFixed(0)} XAF'),
                      if (cart.couponDiscount > 0)
                        _SummaryRow(
                            label: 'Réduction (${cart.couponCode})',
                            value:
                                '-${cart.couponDiscount.toStringAsFixed(0)} XAF',
                            isDiscount: true),
                      const Divider(),
                      _SummaryRow(
                          label: 'Total',
                          value:
                              '${cart.total.toStringAsFixed(0)} XAF',
                          isBold: true),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => context.push('/checkout'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(
                  'Commander · ${cart.total.toStringAsFixed(0)} XAF',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : null,
              fontSize: isBold ? 16 : null,
            ),
          ),
        ],
      ),
    );
  }
}

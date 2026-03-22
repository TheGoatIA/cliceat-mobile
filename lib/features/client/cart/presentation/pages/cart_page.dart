import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../bloc/cart_cubit.dart';
=======
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/widgets/primary_button.dart';
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cart.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
<<<<<<< HEAD
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    'cart.empty'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'cart.empty_subtitle'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _buildCartItem(context, item, state);
                      },
                    ),
                  ),
                  _buildSummary(context, state),
                ],
              ),
            ),
          );
        },
=======
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: 2, // Fake items
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return _buildCartItem(context, index);
                  },
                ),
              ),
              _buildSummary(context),
            ],
          ),
        ),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildCartItem(BuildContext context, CartItem item, CartState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
=======
  Widget _buildCartItem(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
<<<<<<< HEAD
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Center(
            child: Icon(Icons.fastfood,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
=======
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=300&auto=format&fit=crop'),
              fit: BoxFit.cover,
            )
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
<<<<<<< HEAD
                item.name,
=======
                'Menu Burger Classic',
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
<<<<<<< HEAD
                '${(item.price * item.quantity).toStringAsFixed(0)} FCFA',
=======
                '4000 FCFA',
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                HapticFeedback.selectionClick();
<<<<<<< HEAD
                context
                    .read<CartCubit>()
                    .updateQuantity(item.id, item.quantity - 1);
              },
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
=======
              },
            ),
            const Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                HapticFeedback.selectionClick();
<<<<<<< HEAD
                context
                    .read<CartCubit>()
                    .updateQuantity(item.id, item.quantity + 1);
=======
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              },
            ),
          ],
        )
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildSummary(BuildContext context, CartState state) {
    final deliveryFee = state.deliveryFee;
    final total = state.subtotal + deliveryFee;

=======
  Widget _buildSummary(BuildContext context) {
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('cart.sub_total'.tr()),
<<<<<<< HEAD
                Text('${state.subtotal.toStringAsFixed(0)} FCFA'),
=======
                const Text('8000 FCFA'),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('cart.delivery_fee'.tr()),
<<<<<<< HEAD
                Text('${deliveryFee.toStringAsFixed(0)} FCFA'),
=======
                const Text('1000 FCFA'),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
<<<<<<< HEAD
                Text('cart.total'.tr(),
                    style: Theme.of(context).textTheme.titleLarge),
                Text(
                  '${total.toStringAsFixed(0)} FCFA',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
=======
                Text('cart.total'.tr(), style: Theme.of(context).textTheme.titleLarge),
                Text('9000 FCFA', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )),
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
<<<<<<< HEAD
              text:
                  '${'cart.checkout_btn'.tr()} (${total.toStringAsFixed(0)} FCFA)',
=======
              text: '${'cart.checkout_btn'.tr()} (9000 FCFA)',
>>>>>>> f4ae7071d0194c2614232d12bef533974729effa
              onPressed: () {
                context.push('/checkout');
              },
            ),
          ],
        ),
      ),
    );
  }
}

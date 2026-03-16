import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/network/services/coupon_service.dart';
import '../bloc/order_bloc.dart';
import '../bloc/cart_cubit.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'orange_money';
  final TextEditingController _couponController = TextEditingController();
  double _couponDiscount = 0.0;
  String? _couponMessage;
  bool _couponLoading = false;
  String? _appliedCouponCode;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _validateCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    setState(() { _couponLoading = true; _couponMessage = null; });
    try {
      final res = await getIt<CouponService>().validateCoupon(code);
      if (res.isSuccessful && res.body != null) {
        final data = res.body!['data'] as Map<String, dynamic>?;
        final discount = (data?['discountAmount'] as num?)?.toDouble() ?? 0.0;
        setState(() {
          _couponDiscount = discount;
          _appliedCouponCode = code;
          _couponMessage = 'checkout.coupon_applied'.tr(args: [discount.toStringAsFixed(0)]);
        });
      } else {
        final msg = (res.body as Map<String, dynamic>?)?['message']?.toString() ?? 'checkout.coupon_invalid'.tr();
        setState(() { _couponDiscount = 0.0; _appliedCouponCode = null; _couponMessage = msg; });
      }
    } catch (_) {
      setState(() { _couponMessage = 'checkout.coupon_error'.tr(); });
    } finally {
      setState(() { _couponLoading = false; });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('checkout.title'.tr(), style: const TextStyle(fontSize: 18)),
        ),
        body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressSection(context),
                const SizedBox(height: 24),
                _buildOrderSummary(context),
                const SizedBox(height: 24),
                _buildCouponSection(context),
                const SizedBox(height: 24),
                _buildPaymentMethods(context),
                BlocConsumer<OrderBloc, OrderState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      created: (orderId, paymentUrl) {
                        if (paymentUrl != null && paymentUrl.isNotEmpty) {
                          context.push('/payment', extra: paymentUrl);
                        } else {
                          context.push('/order-success', extra: orderId);
                        }
                      },
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, orderState) {
                    final isLoading = orderState.maybeWhen(loading: () => true, orElse: () => false);
                    return PrimaryButton(
                      text: isLoading ? '...' : 'checkout.confirm_pay'.tr(),
                      onPressed: isLoading ? () {} : () {
                        HapticFeedback.mediumImpact();

                        final cartState = context.read<CartCubit>().state;
                        final items = cartState.items.map((item) => {
                          "menuItemId": item.itemId,
                          "quantity": item.quantity,
                        }).toList();

                        final payload = {
                          "restaurantId": cartState.restaurantId ?? '',
                          "paymentMethod": _selectedPaymentMethod,
                          "deliveryAddress": {
                            "address": "Douala, Cameroun",
                            "lat": 4.0511,
                            "lng": 9.7679,
                          },
                          "items": items,
                          if (_appliedCouponCode != null) "couponCode": _appliedCouponCode,
                        };

                        context.read<OrderBloc>().add(OrderEvent.createOrder(payload));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildAddressSection(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('checkout.delivery_address'.tr(), style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text('123 Rue de la Paix, Douala\nCameroun', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push('/address-selection'),
              child: Text('checkout.change'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        const deliveryFee = 1000.0;
        final total = (cartState.subtotal + deliveryFee - _couponDiscount).clamp(0.0, double.infinity);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('checkout.summary'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('cart.sub_total'.tr()), Text('${cartState.subtotal.toStringAsFixed(0)} FCFA')],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('cart.delivery_fee'.tr()), const Text('1000 FCFA')],
            ),
            if (_couponDiscount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('checkout.coupon_discount'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  Text('-${_couponDiscount.toStringAsFixed(0)} FCFA', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('cart.total'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                 Text('${total.toStringAsFixed(0)} FCFA', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
               ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'checkout.enter_coupon'.tr(),
                  prefixIcon: const Icon(Icons.local_offer_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _couponLoading ? null : () {
                HapticFeedback.selectionClick();
                _validateCoupon();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _couponLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('checkout.apply'.tr()),
            ),
          ],
        ),
        if (_couponMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _couponMessage!,
            style: TextStyle(
              color: _couponDiscount > 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('checkout.payment_method'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPaymentOption('orange_money', 'Orange Money', Icons.phone_android),
        const SizedBox(height: 8),
        _buildPaymentOption('mtn_momo', 'MTN Mobile Money', Icons.phone_android),
        const SizedBox(height: 8),
        _buildPaymentOption('cash', 'checkout.cash_on_delivery'.tr(), Icons.money),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedPaymentMethod = value);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

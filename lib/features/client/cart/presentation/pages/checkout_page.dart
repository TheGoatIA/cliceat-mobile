import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/models/coupon_model.dart';
import '../../../../../core/repositories/coupon_repository.dart';
import '../bloc/order_bloc.dart';
import '../bloc/cart_cubit.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'orange_money';
  final _couponController = TextEditingController();
  final _notesController = TextEditingController();

  CouponModel? _appliedCoupon;
  double _couponDiscount = 0.0;
  String? _couponMessage;
  bool _couponLoading = false;

  Map<String, dynamic>? _selectedAddress;

  @override
  void dispose() {
    _couponController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _validateCoupon(BuildContext context) async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _couponLoading = true;
      _couponMessage = null;
    });

    final result = await getIt<CouponRepository>().validateCoupon(code);
    if (!mounted) return;

    result.fold(
      (err) => setState(() {
        _couponDiscount = 0.0;
        _appliedCoupon = null;
        _couponMessage = err.message.tr();
        _couponLoading = false;
      }),
      (coupon) {
        // Compute discount against current cart subtotal
        final subtotal = context.read<CartCubit>().state.subtotal;
        final discount = coupon.computeDiscount(subtotal);
        setState(() {
          _appliedCoupon = coupon;
          _couponDiscount = discount;
          _couponMessage = 'checkout.coupon_applied'.tr(
            args: [code, discount.toStringAsFixed(0)],
          );
          _couponLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('checkout.title'.tr()),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(context),
                  const SizedBox(height: 20),
                  _buildOrderSummary(context),
                  const SizedBox(height: 20),
                  _buildCouponSection(context),
                  const SizedBox(height: 20),
                  _buildPaymentMethods(context),
                  const SizedBox(height: 20),
                  _buildNotesSection(context),
                  const SizedBox(height: 8),
                  BlocConsumer<OrderBloc, OrderState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        created: (orderId, paymentUrl) {
                          context.read<CartCubit>().clearCart();
                          if (paymentUrl != null &&
                              paymentUrl.isNotEmpty) {
                            context.push('/client/payment', extra: {
                              'paymentUrl': paymentUrl,
                              'orderId': orderId,
                            });
                          } else {
                            context
                                .go('/client/order-success/$orderId');
                          }
                        },
                        error: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, orderState) {
                      final isLoading = orderState.maybeWhen(
                          loading: () => true, orElse: () => false);
                      return PrimaryButton(
                        text: 'checkout.confirm_pay'.tr(),
                        isLoading: isLoading,
                        onPressed: () => _onConfirm(context),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onConfirm(BuildContext context) {
    HapticFeedback.mediumImpact();
    final cartState = context.read<CartCubit>().state;
    final restaurantId = cartState.restaurantId ?? '';
    if (restaurantId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('cart.empty'.tr())),
      );
      return;
    }

    final items = cartState.items
        .map((item) => {
              'menuItemId': item.itemId,
              'quantity': item.quantity,
            })
        .toList();

    final notes = _notesController.text.trim();
    final payload = {
      'restaurantId': restaurantId,
      'paymentMethod': _selectedPaymentMethod,
      'deliveryAddress': {
        'address':
            _selectedAddress?['address'] ?? AppConstants.defaultCity,
        'lat': (_selectedAddress?['lat'] as num?)?.toDouble() ??
            AppConstants.defaultLat,
        'lng': (_selectedAddress?['lng'] as num?)?.toDouble() ??
            AppConstants.defaultLng,
      },
      'items': items,
      if (_appliedCoupon != null) 'couponCode': _appliedCoupon!.code,
      if (notes.isNotEmpty) 'notes': notes,
    };

    context.read<OrderBloc>().add(OrderEvent.createOrder(payload));
  }

  Widget _buildAddressSection(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.location_on, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('checkout.delivery_address'.tr(),
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    _selectedAddress?['address'] as String? ??
                        AppConstants.defaultCity,
                    style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final addr =
                    await context.push<Map<String, dynamic>>(
                        '/client/address-selection');
                if (addr != null && mounted) {
                  setState(() => _selectedAddress = addr);
                }
              },
              child: Text('checkout.change'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final deliveryFee = cartState.deliveryFee;
        final total = (cartState.subtotal + deliveryFee - _couponDiscount)
            .clamp(0.0, double.infinity);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'checkout.summary'.tr(),
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _summaryRow(
              context,
              'cart.sub_total'.tr(),
              '${cartState.subtotal.toStringAsFixed(0)} FCFA',
            ),
            const SizedBox(height: 6),
            _summaryRow(
              context,
              'cart.delivery_fee'.tr(),
              '${deliveryFee.toStringAsFixed(0)} FCFA',
            ),
            if (_couponDiscount > 0) ...[
              const SizedBox(height: 6),
              _summaryRow(
                context,
                'checkout.coupon_discount'.tr(),
                '-${_couponDiscount.toStringAsFixed(0)} FCFA',
                valueColor: theme.colorScheme.primary,
              ),
            ],
            const Divider(height: 24),
            _summaryRow(
              context,
              'cart.total'.tr(),
              '${total.toStringAsFixed(0)} FCFA',
              bold: true,
              valueColor: theme.colorScheme.primary,
            ),
          ],
        );
      },
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    final style = bold
        ? const TextStyle(fontWeight: FontWeight.bold)
        : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value,
            style:
                style?.copyWith(color: valueColor) ??
                    TextStyle(color: valueColor)),
      ],
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    final theme = Theme.of(context);
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _couponLoading
                  ? null
                  : () {
                      HapticFeedback.selectionClick();
                      _validateCoupon(context);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _couponLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child:
                          CircularProgressIndicator(strokeWidth: 2))
                  : Text('checkout.apply'.tr()),
            ),
          ],
        ),
        if (_couponMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _couponMessage!,
            style: TextStyle(
              color: _couponDiscount > 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'checkout.payment_method'.tr(),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(context, 'orange_money', 'Orange Money',
            Icons.phone_android),
        const SizedBox(height: 8),
        _buildPaymentOption(context, 'mtn_momo', 'MTN Mobile Money',
            Icons.phone_android),
        const SizedBox(height: 8),
        _buildPaymentOption(context, 'cash',
            'checkout.cash_on_delivery'.tr(), Icons.money),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String value,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedPaymentMethod = value);
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle,
                  color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'checkout.notes'.tr(),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'checkout.notes_hint'.tr(),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.note_outlined),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

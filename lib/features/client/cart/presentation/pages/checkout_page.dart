import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_protector/screen_protector.dart';
import '../../../../../core/config/app_constants.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/cart/data/models/coupon_model.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/coupon_repository.dart';
import '../../../../../core/theme/app_theme.dart';
import '../bloc/order_bloc.dart';
import '../bloc/cart_cubit.dart';
import '../../../../../core/services/analytics_service.dart';
import 'package:cliceat_app/core/config/feature_flags.dart';
import 'package:cliceat_app/core/widgets/feature_gate.dart';

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
  void initState() {
    super.initState();
    ScreenProtector.preventScreenshotOn();
    final subtotal = context.read<CartCubit>().state.subtotal;
    getIt<AnalyticsService>().logBeginCheckout(subtotal);
  }

  @override
  void dispose() {
    _couponController.dispose();
    _notesController.dispose();
    ScreenProtector.preventScreenshotOff();
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
        backgroundColor: AppTheme.bg,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.line),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18, color: AppTheme.ink),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'checkout.title'.tr(),
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAddressSection(context),
                          const SizedBox(height: 16),
                          _buildOrderSummary(context),
                          const SizedBox(height: 16),
                          FeatureGate(
                            featureKey: FeatureFlags.coupons,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildCouponSection(context),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          _buildPaymentMethods(context),
                          const SizedBox(height: 16),
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
                                    context.go('/client/order-success/$orderId');
                                  }
                                },
                                error: (message) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: AppTheme.primaryRed,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  );
                                },
                                orElse: () {},
                              );
                            },
                            builder: (context, orderState) {
                              final isLoading = orderState.maybeWhen(
                                  loading: () => true, orElse: () => false);
                              return SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed:
                                      isLoading ? null : () => _onConfirm(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryRed,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'checkout.confirm_pay'.tr(),
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
      if (notes.isNotEmpty) 'deliveryNotes': notes,
    };

    context.read<OrderBloc>().add(OrderEvent.createOrder(payload));
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return _buildSection(
      title: 'checkout.delivery_address'.tr(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.redSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.location_on_rounded,
                  color: AppTheme.primaryRed, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedAddress?['address'] as String? ??
                    AppConstants.defaultCity,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.inkSoft,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                HapticFeedback.lightImpact();
                final addr =
                    await context.push<Map<String, dynamic>>(
                        '/client/address-selection');
                if (addr != null && mounted) {
                  setState(() => _selectedAddress = addr);
                }
              },
              child: Text(
                'checkout.change'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final deliveryFee = cartState.deliveryFee;
        final total = (cartState.subtotal + deliveryFee - _couponDiscount)
            .clamp(0.0, double.infinity);
        return _buildSection(
          title: 'checkout.summary'.tr(),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.lineSoft),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'cart.sub_total'.tr(),
                  value: '${cartState.subtotal.toStringAsFixed(0)} FCFA',
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'cart.delivery_fee'.tr(),
                  value: '${deliveryFee.toStringAsFixed(0)} FCFA',
                ),
                if (_couponDiscount > 0) ...[
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'checkout.coupon_discount'.tr(),
                    value: '-${_couponDiscount.toStringAsFixed(0)} FCFA',
                    valueColor: AppTheme.green,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(height: 1, color: AppTheme.lineSoft),
                ),
                _SummaryRow(
                  label: 'cart.total'.tr(),
                  value: '${total.toStringAsFixed(0)} FCFA',
                  bold: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    return _buildSection(
      title: 'checkout.promo_code'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.lineSoft),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(
                  Icons.local_offer_outlined,
                  size: 20,
                  color: AppTheme.primaryRed,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: 'checkout.enter_coupon'.tr(),
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.mutedLight,
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _couponLoading
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          _validateCoupon(context);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: _couponLoading ? AppTheme.muted : AppTheme.ink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _couponLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'checkout.apply'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_couponMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _couponMessage!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: _couponDiscount > 0
                    ? AppTheme.green
                    : AppTheme.primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    return _buildSection(
      title: 'checkout.payment_method'.tr(),
      child: Column(
        children: [
          _buildPaymentOption(context, 'orange_money', 'checkout.orange_money'.tr(), '🟠'),
          const SizedBox(height: 8),
          _buildPaymentOption(context, 'mtn_momo', 'checkout.mtn_momo'.tr(), '🟡'),
          const SizedBox(height: 8),
          _buildPaymentOption(context, 'wallet', 'wallet.title'.tr(), '💳'),
          const SizedBox(height: 8),
          _buildPaymentOption(context, 'cash', 'checkout.cash_on_delivery'.tr(), '💵'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String value,
    String title,
    String emoji,
  ) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedPaymentMethod = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.redSoft : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryRed : AppTheme.lineSoft,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected ? [] : AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.primaryRed : AppTheme.inkSoft,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppTheme.primaryRed, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return _buildSection(
      title: 'checkout.notes'.tr(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.line),
        ),
        child: TextField(
          controller: _notesController,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.ink),
          decoration: InputDecoration(
            hintText: 'checkout.notes_hint'.tr(),
            hintStyle:
                GoogleFonts.inter(fontSize: 14, color: AppTheme.mutedLight),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? AppTheme.ink : AppTheme.muted,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? (bold ? AppTheme.primaryRed : AppTheme.inkSoft),
          ),
        ),
      ],
    );
  }
}

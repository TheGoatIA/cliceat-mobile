import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/cart/data/models/order_model.dart';
import 'package:cliceat_app/features/client/cart/data/repositories/order_repository.dart';
import '../../../../../core/theme/app_theme.dart';
import '../bloc/cart_cubit.dart';

class OrderSuccessPage extends StatefulWidget {
  final String orderId;

  const OrderSuccessPage({super.key, required this.orderId});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  OrderModel? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Clear the cart when order success page is reached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().clearCart();
      }
    });
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    if (widget.orderId.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final result = await getIt<OrderRepository>().getOrderById(widget.orderId);
    if (mounted) {
      result.fold(
        (_) => setState(() => _loading = false),
        (order) => setState(() {
          _order = order;
          _loading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortId = widget.orderId.length > 12
        ? widget.orderId.substring(widget.orderId.length - 12)
        : widget.orderId;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Success animation circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.greenSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: AppTheme.green,
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  _loading
                      ? 'order.success_title'.tr()
                      : (_order?.paymentMethod?.toLowerCase() == 'cash'
                          ? 'Commande enregistrée !'
                          : 'order.success_title'.tr()),
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                    letterSpacing: -0.8,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _loading
                      ? 'order.success_message'.tr()
                      : (_order?.paymentMethod?.toLowerCase() == 'cash'
                          ? 'Votre commande avec paiement à la livraison a été enregistrée. Elle sera traitée dès qu\'un administrateur l\'aura confirmée.'
                          : 'order.success_message'.tr()),
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppTheme.muted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Order ID box
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.lineSoft),
                    boxShadow: AppTheme.shadowSm,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'order.order_id'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        shortId,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ETA badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.honeySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer_outlined,
                          color: AppTheme.honey, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'order.estimated_delivery'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Track button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/client/tracking/${widget.orderId}'),
                    icon: const Icon(Icons.location_on_rounded, size: 18),
                    label: Text(
                      'order.track_order'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Back to home
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => context.go('/client'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.inkSoft,
                      side: const BorderSide(color: AppTheme.line),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'order.back_to_home'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
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

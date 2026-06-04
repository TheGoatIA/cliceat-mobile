import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/repositories/order_repository.dart';

class OrderRatingPage extends StatefulWidget {
  final String orderId;
  const OrderRatingPage({super.key, required this.orderId});

  @override
  State<OrderRatingPage> createState() => _OrderRatingPageState();
}

class _OrderRatingPageState extends State<OrderRatingPage>
    with SingleTickerProviderStateMixin {
  int _restaurantRating = 0;
  int _deliveryRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  bool _submitted = false;

  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_restaurantRating == 0 || _deliveryRating == 0) return;

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final result = await getIt<OrderRepository>().rateOrder(
      widget.orderId,
      _restaurantRating,
      _deliveryRating,
      _commentController.text.trim().isNotEmpty
          ? _commentController.text.trim()
          : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.message.tr()),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      (_) {
        setState(() => _submitted = true);
        _confettiController.forward();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) context.go('/client');
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'order.rate_order_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppTheme.ink),
          onPressed: () => context.go('/client'),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _submitted ? _buildSuccessView() : _buildRatingForm(),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      key: const ValueKey('success'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _confettiController,
              curve: Curves.elasticOut,
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppTheme.successColor,
                size: 52,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'order.rating_thanks_title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'order.rating_thanks_subtitle'.tr(),
            style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingForm() {
    final canSubmit = _restaurantRating > 0 && _deliveryRating > 0;

    return Center(
      key: const ValueKey('form'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppTheme.redSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.primaryRed,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'order.delivered_title'.tr(),
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'order.how_was_experience'.tr(),
                style: GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              _buildRatingCard(
                icon: Icons.restaurant_rounded,
                iconColor: AppTheme.primaryRed,
                iconBg: AppTheme.redSoft,
                title: 'order.restaurant_rating_title'.tr(),
                subtitle: 'order.restaurant_rating_subtitle'.tr(),
                currentRating: _restaurantRating,
                onRatingChanged: (r) {
                  HapticFeedback.selectionClick();
                  setState(() => _restaurantRating = r);
                },
              ),
              const SizedBox(height: 16),
              _buildRatingCard(
                icon: Icons.delivery_dining_rounded,
                iconColor: AppTheme.primaryRed,
                iconBg: AppTheme.redSoft,
                title: 'order.delivery_rating_title'.tr(),
                subtitle: 'order.delivery_rating_subtitle'.tr(),
                currentRating: _deliveryRating,
                onRatingChanged: (r) {
                  HapticFeedback.selectionClick();
                  setState(() => _deliveryRating = r);
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.lineSoft),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'order.rate_comment_hint'.tr(),
                    hintStyle: GoogleFonts.inter(
                        color: AppTheme.mutedLight, fontSize: 14),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 52),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppTheme.muted,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: canSubmit ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: canSubmit && !_isLoading ? _submitRating : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white),
                          )
                        : Text(
                            'order.submit_rating'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              if (!canSubmit)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'order.rating_required_hint'.tr(),
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppTheme.muted),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required int currentRating,
    required Function(int) onRatingChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppTheme.ink,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final filled = index < currentRating;
              return GestureDetector(
                onTap: () => onRatingChanged(index + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      key: ValueKey(filled),
                      color: filled ? AppTheme.honey : AppTheme.lineSoft,
                      size: 40,
                    ),
                  ),
                ),
              );
            }),
          ),
          if (currentRating > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _getRatingLabel(currentRating),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _getRatingColor(currentRating),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getRatingLabel(int rating) {
    return switch (rating) {
      1 => 'order.rating_1'.tr(),
      2 => 'order.rating_2'.tr(),
      3 => 'order.rating_3'.tr(),
      4 => 'order.rating_4'.tr(),
      5 => 'order.rating_5'.tr(),
      _ => '',
    };
  }

  Color _getRatingColor(int rating) {
    return switch (rating) {
      1 || 2 => AppTheme.errorColor,
      3 => AppTheme.statusPending,
      4 || 5 => AppTheme.successColor,
      _ => AppTheme.muted,
    };
  }
}

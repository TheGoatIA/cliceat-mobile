import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../bloc/mission_bloc.dart';
import '../../data/models/mission_model.dart';

class ConfirmPickupPage extends StatefulWidget {
  final MissionModel mission;
  const ConfirmPickupPage({super.key, required this.mission});

  @override
  State<ConfirmPickupPage> createState() => _ConfirmPickupPageState();
}

class _ConfirmPickupPageState extends State<ConfirmPickupPage> {
  bool _isSubmitting = false;

  void _onConfirm() {
    HapticFeedback.heavyImpact();
    setState(() => _isSubmitting = true);

    context.read<MissionBloc>().add(MissionEvent.updateStatus(
          widget.mission.id,
          'picked_up',
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<MissionBloc, MissionState>(
      listener: (context, state) {
        state.maybeWhen(
          actionSuccess: (msg) {
            setState(() => _isSubmitting = false);
            context.pushReplacement('/delivery/dropoff', extra: widget.mission);
          },
          error: (msg) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg.tr()),
                backgroundColor: AppTheme.primaryRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'delivery.confirm_pickup_title'.tr(args: [widget.mission.id.substring(widget.mission.id.length - 5)]),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRestaurantHeader(theme),
                  const SizedBox(height: 24),
                  Text(
                    'delivery.items_count'.tr(args: [widget.mission.items.length.toString()]),
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppTheme.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.mission.items.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = widget.mission.items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_box_outline_blank, color: AppTheme.statusPending),
                          title: Text('${item.quantity}x ${item.name}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isSubmitting)
                    const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryRed, strokeWidth: 2),
                    )
                  else
                    _buildSlider(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.redSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: AppTheme.primaryRed, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mission.restaurantName ?? 'Restaurant',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.ink),
                ),
                Text(
                  'delivery.verify_items'.tr(),
                  style:
                      GoogleFonts.inter(fontSize: 13, color: AppTheme.muted),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSlider(ThemeData theme) {
    return Dismissible(
      key: const Key('pickup_slider'),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        _onConfirm();
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
            color: AppTheme.primaryRed,
            borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
      ),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.primaryRed,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryRed.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 5,
              top: 4,
              bottom: 4,
              child: Container(
                width: 52,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppTheme.primaryRed, size: 18),
              ),
            ),
            Center(
              child: Text(
                'delivery.confirm_pickup'.tr(),
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

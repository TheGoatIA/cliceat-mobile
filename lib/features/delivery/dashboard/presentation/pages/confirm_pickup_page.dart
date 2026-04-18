import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            // After pickup, we navigate to the dropoff (delivery) phase
            context.pushReplacement('/delivery/dropoff', extra: widget.mission);
          },
          error: (msg) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg.tr()), backgroundColor: AppTheme.errorColor),
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('delivery.confirm_pickup_title'.tr(args: [widget.mission.id.substring(widget.mission.id.length - 5)])),
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
                  Text('delivery.items_count'.tr(args: [widget.mission.items.length.toString()]), 
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                    const Center(child: CircularProgressIndicator())
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
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.restaurant, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.mission.restaurantName ?? 'Restaurant', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('delivery.verify_items'.tr()),
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
        decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.check, color: Colors.white, size: 32),
      ),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 5, top: 4, bottom: 4,
              child: Container(
                width: 52,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
              ),
            ),
            Center(
              child: Text('delivery.confirm_pickup'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

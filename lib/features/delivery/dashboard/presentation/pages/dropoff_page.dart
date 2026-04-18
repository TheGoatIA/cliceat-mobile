import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../bloc/mission_bloc.dart';
import '../../data/models/mission_model.dart';

class DropoffPage extends StatefulWidget {
  final MissionModel mission;
  const DropoffPage({super.key, required this.mission});

  @override
  State<DropoffPage> createState() => _DropoffPageState();
}

class _DropoffPageState extends State<DropoffPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  bool get _requiresCode => widget.mission.paymentMethod?.toLowerCase() == 'cash';

  void _onConfirm() {
    if (_requiresCode && (_codeController.text.isEmpty || _codeController.text.length < 4)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('delivery.error_code_required'.tr()),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() => _isSubmitting = true);

    context.read<MissionBloc>().add(MissionEvent.updateStatus(
          widget.mission.id,
          'delivered',
          metadata: {
            if (_codeController.text.isNotEmpty) 'confirmationCode': _codeController.text,
          },
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
            context.go('/delivery');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('delivery.delivery_success_bonus'.tr(args: ['1 500'])),
                backgroundColor: AppTheme.successColor,
              ),
            );
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
          title: Text('delivery.dropoff_client'.tr()),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildClientInfo(theme),
                    const SizedBox(height: 32),
                    _buildPaymentInfo(theme),
                    const SizedBox(height: 32),
                    if (_requiresCode) ...[
                      Text(
                        'delivery.enter_confirmation_code'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: '123456',
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    if (_isSubmitting)
                      const Center(child: CircularProgressIndicator())
                    else
                      _buildSlider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.successColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_pin_circle, size: 48, color: AppTheme.successColor),
          const SizedBox(height: 12),
          Text(
            widget.mission.clientName ?? 'Client',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(widget.mission.deliveryAddress?.address ?? 'Akwa, Douala'),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(ThemeData theme) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text('delivery.payment_title'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
         const SizedBox(height: 12),
         Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(
             color: theme.cardTheme.color,
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
           ),
           child: Row(
             children: [
               Icon(
                 _requiresCode ? Icons.money : Icons.credit_card,
                 color: _requiresCode ? Colors.green : theme.colorScheme.primary,
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: Text(
                   _requiresCode ? 'delivery.cash_to_collect'.tr() : 'delivery.online_paid'.tr(),
                   style: const TextStyle(fontWeight: FontWeight.w600),
                 ),
               ),
               Text(
                 '${widget.mission.earnings.toStringAsFixed(0)} FCFA',
                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
               ),
             ],
           ),
         ),
       ],
     );
  }

  Widget _buildSlider() {
    return Dismissible(
      key: const Key('dropoff_slider'),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        if (_requiresCode && _codeController.text.length < 4) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('delivery.error_code_short'.tr()), backgroundColor: AppTheme.errorColor),
           );
           return false;
        }
        _onConfirm();
        return false; // We handle the dismissal via Bloc
      },
      background: Container(
        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.check, color: Colors.white, size: 32),
      ),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 5, top: 4, bottom: 4,
              child: Container(
                width: 52,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios, color: Colors.green),
              ),
            ),
            Center(
              child: Text('delivery.confirm_dropoff'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

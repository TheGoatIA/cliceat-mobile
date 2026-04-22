import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return BlocListener<MissionBloc, MissionState>(
      listener: (context, state) {
        state.maybeWhen(
          actionSuccess: (msg) {
            setState(() => _isSubmitting = false);
            context.go('/delivery');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('delivery.delivery_success_bonus'.tr(args: ['1 500'])),
                backgroundColor: AppTheme.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
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
            'delivery.dropoff_client'.tr(),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildClientInfo(Theme.of(context)),
                    const SizedBox(height: 32),
                    _buildPaymentInfo(Theme.of(context)),
                    const SizedBox(height: 32),
                    if (_requiresCode) ...[
                      Text(
                        'delivery.enter_confirmation_code'.tr(),
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppTheme.ink),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.line),
                        ),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink,
                            letterSpacing: 2,
                          ),
                          decoration: InputDecoration(
                            hintText: '123456',
                            hintStyle: GoogleFonts.inter(
                                fontSize: 16, color: AppTheme.mutedLight),
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: AppTheme.muted, size: 20),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    if (_isSubmitting)
                      const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryRed, strokeWidth: 2),
                      )
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
        color: AppTheme.greenSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_pin_circle, size: 48, color: AppTheme.green),
          const SizedBox(height: 12),
          Text(
            widget.mission.clientName ?? 'Client',
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.mission.deliveryAddress?.address ?? 'Akwa, Douala',
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery.payment_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _requiresCode ? AppTheme.honeySoft : AppTheme.greenSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _requiresCode ? Icons.money : Icons.credit_card,
                  color: _requiresCode ? AppTheme.honey : AppTheme.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _requiresCode
                      ? 'delivery.cash_to_collect'.tr()
                      : 'delivery.online_paid'.tr(),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.ink),
                ),
              ),
              Text(
                '${widget.mission.earnings.toStringAsFixed(0)} FCFA',
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppTheme.green,
                  letterSpacing: -0.3,
                ),
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
            SnackBar(
              content: Text('delivery.error_code_short'.tr()),
              backgroundColor: AppTheme.primaryRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          return false;
        }
        _onConfirm();
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
            color: AppTheme.green, borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
      ),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.green,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.green.withValues(alpha: 0.4),
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
                    color: AppTheme.green, size: 18),
              ),
            ),
            Center(
              child: Text(
                'delivery.confirm_dropoff'.tr(),
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

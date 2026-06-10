import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../bloc/mission_bloc.dart';
import '../../data/models/mission_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/cart/data/datasources/order_service.dart';

class DropoffPage extends StatefulWidget {
  final MissionModel mission;
  const DropoffPage({super.key, required this.mission});

  @override
  State<DropoffPage> createState() => _DropoffPageState();
}

class _DropoffPageState extends State<DropoffPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pinFocusNode = FocusNode();
  bool _isSubmitting = false;
  late MissionModel _mission;

  @override
  void initState() {
    super.initState();
    _mission = widget.mission;
    _loadFreshMission();
  }

  Future<void> _loadFreshMission() async {
    try {
      final response = await getIt<OrderService>().getOrderById(_mission.id);
      if (response.isSuccessful && response.body != null && mounted) {
        final data =
            response.body!['data'] as Map<String, dynamic>? ?? response.body!;
        final orderData = data['order'] as Map<String, dynamic>? ?? data;
        setState(() {
          _mission = MissionModel.fromJson(orderData);
        });
      }
    } catch (e, s) {
      debugPrint('[dropoff_page.dart] error: $e\n$s');
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  bool get _requiresCode => _mission.paymentMethod?.toLowerCase() == 'cash';

  Widget _buildPinInput() {
    final codeLength = _codeController.text.length;
    return GestureDetector(
      onTap: () {
        _pinFocusNode.requestFocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              final isFilled = codeLength > index;
              final isFocused = codeLength == index;
              final digit = isFilled ? _codeController.text[index] : '';

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isFocused
                        ? AppTheme.primaryRed
                        : (isFilled ? AppTheme.ink : AppTheme.line),
                    width: isFocused ? 2.5 : 1.5,
                  ),
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryRed.withValues(alpha: 0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : AppTheme.shadowSm,
                ),
                child: Text(
                  digit,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                    letterSpacing: -0.5,
                  ),
                ),
              );
            }),
          ),
          // Hidden TextFormField capturing the actual keyboard input
          SizedBox(
            height: 0,
            width: 0,
            child: Opacity(
              opacity: 0,
              child: TextFormField(
                controller: _codeController,
                focusNode: _pinFocusNode,
                keyboardType: TextInputType.number,
                maxLength: 4,
                showCursor: false,
                enableInteractiveSelection: false,
                onChanged: (val) {
                  setState(() {});
                  HapticFeedback.lightImpact();
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    if (_requiresCode &&
        (_codeController.text.isEmpty || _codeController.text.length < 4)) {
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

    context.read<MissionBloc>().add(
      MissionEvent.updateStatus(
        _mission.id,
        'delivered',
        metadata: {
          if (_codeController.text.isNotEmpty)
            'confirmationCode': _codeController.text,
        },
      ),
    );
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
                content: Text(
                  'delivery.delivery_success_bonus'.tr(args: ['1 500']),
                ),
                backgroundColor: AppTheme.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                  borderRadius: BorderRadius.circular(12),
                ),
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
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPinInput(),
                      const SizedBox(height: 32),
                    ],

                    if (_isSubmitting)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryRed,
                          strokeWidth: 2,
                        ),
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
            _mission.clientName ?? 'Client',
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _mission.deliveryAddress?.address ?? 'Akwa, Douala',
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
          ),
          if (_mission.clientPhone != null &&
              _mission.clientPhone!.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final phone = _mission.clientPhone;
                  if (phone == null || phone.isEmpty) return;
                  HapticFeedback.mediumImpact();
                  final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
                  final uri = Uri.parse('tel:$cleaned');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                label: Text(
                  'Appeler le client',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
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
                  color: _requiresCode
                      ? AppTheme.honeySoft
                      : AppTheme.greenSoft,
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
                    color: AppTheme.ink,
                  ),
                ),
              ),
              Text(
                '${(_requiresCode ? _mission.total : _mission.earnings).toStringAsFixed(0)} FCFA',
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
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return false;
        }
        _onConfirm();
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.green,
          borderRadius: BorderRadius.circular(30),
        ),
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.green,
                  size: 18,
                ),
              ),
            ),
            Center(
              child: Text(
                'delivery.confirm_dropoff'.tr(),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/delivery/dashboard/presentation/bloc/payout_cubit.dart';

class PayoutPage extends StatefulWidget {
  const PayoutPage({super.key});

  @override
  State<PayoutPage> createState() => _PayoutPageState();
}

class _PayoutPageState extends State<PayoutPage> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PayoutCubit>()..loadPayoutData(),
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'payout.title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: BlocBuilder<PayoutCubit, PayoutState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primaryRed, strokeWidth: 2),
              ),
              loaded: (payouts, account) => _buildContent(context, payouts, account),
              error: (msg) => Center(
                child: Text(msg,
                    style: GoogleFonts.inter(
                        color: AppTheme.primaryRed, fontSize: 14)),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Map<String, dynamic>> payouts,
      Map<String, dynamic>? account) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAccountCard(context, account),
          const SizedBox(height: 20),
          _buildPayoutAction(context),
          const SizedBox(height: 28),
          Text(
            'payout.history'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          if (payouts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'payout.no_history'.tr(),
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
                ),
              ),
            )
          else
            ...payouts.map((p) => _buildPayoutItem(context, p)),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, Map<String, dynamic>? account) {
    final hasAccount = account != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'payout.linked_account'.tr(),
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.ink),
              ),
              GestureDetector(
                onTap: () => _showAccountDialog(context, account),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.redSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit,
                      size: 16, color: AppTheme.primaryRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasAccount) ...[
            Text(
              '${'payout.method'.tr()}: ${account['method']?.toString().toUpperCase() ?? ''}',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
            ),
            const SizedBox(height: 4),
            Text(
              '${'payout.number'.tr()}: ${account['phoneNumber'] ?? ''}',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
            ),
            const SizedBox(height: 4),
            Text(
              '${'payout.name'.tr()}: ${account['accountName'] ?? ''}',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.inkSoft),
            ),
          ] else
            Text(
              'payout.no_account_linked'.tr(),
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.muted,
                  fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }

  Widget _buildPayoutAction(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.line),
          ),
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.inter(fontSize: 15, color: AppTheme.ink),
            decoration: InputDecoration(
              labelText: 'payout.amount_to_withdraw'.tr(),
              labelStyle:
                  GoogleFonts.inter(color: AppTheme.muted, fontSize: 14),
              suffixText: 'FCFA',
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(_amountController.text);
              if (amt != null && amt > 0) {
                context.read<PayoutCubit>().requestPayout(amt);
                _amountController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'payout.request_withdraw'.tr(),
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayoutItem(BuildContext context, Map<String, dynamic> p) {
    final status = p['status'] as String? ?? 'pending';
    final amount = p['amount']?.toString() ?? '0';
    final date = DateTime.tryParse(p['createdAt'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.lineSoft),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$amount FCFA',
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppTheme.ink,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(date),
                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
              ),
            ],
          ),
          _buildStatusChip(status),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = AppTheme.statusPending;
    if (status == 'processed') color = AppTheme.green;
    if (status == 'rejected') color = AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.tr(),
        style: GoogleFonts.inter(
            color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _showAccountDialog(BuildContext context, Map<String, dynamic>? currentAccount) {
    final methodController =
        TextEditingController(text: currentAccount?['method'] ?? 'momo');
    final phoneController =
        TextEditingController(text: currentAccount?['phoneNumber'] ?? '');
    final nameController =
        TextEditingController(text: currentAccount?['accountName'] ?? '');
    final cubit = context.read<PayoutCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'payout.edit_account'.tr(),
          style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700, fontSize: 18, color: AppTheme.ink),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: methodController.text,
              items: const [
                DropdownMenuItem(
                    value: 'momo', child: Text('MTN Mobile Money')),
                DropdownMenuItem(
                    value: 'om', child: Text('Orange Money')),
              ],
              onChanged: (v) => methodController.text = v!,
              decoration:
                  InputDecoration(labelText: 'payout.method'.tr()),
            ),
            TextField(
              controller: phoneController,
              decoration:
                  InputDecoration(labelText: 'payout.number'.tr()),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'payout.name'.tr()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr(),
                style: GoogleFonts.inter(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.updateAccount(
                method: methodController.text,
                phoneNumber: phoneController.text,
                accountName: nameController.text,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }
}

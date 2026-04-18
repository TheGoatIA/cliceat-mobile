import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/delivery/dashboard/presentation/bloc/payout_cubit.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

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
        appBar: AppBar(
          title: Text('payout.title'.tr()),
        ),
        body: BlocBuilder<PayoutCubit, PayoutState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (payouts, account) => _buildContent(context, payouts, account),
              error: (msg) => Center(child: Text(msg)),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Map<String, dynamic>> payouts, Map<String, dynamic>? account) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAccountCard(context, account),
          const SizedBox(height: 24),
          _buildPayoutAction(context),
          const SizedBox(height: 32),
          Text(
            'payout.history'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (payouts.isEmpty)
             Center(child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Text('payout.no_history'.tr(), style: const TextStyle(color: Colors.grey)),
             ))
          else
            ...payouts.map((p) => _buildPayoutItem(context, p)),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, Map<String, dynamic>? account) {
    final theme = Theme.of(context);
    final hasAccount = account != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('payout.linked_account'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _showAccountDialog(context, account),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasAccount) ...[
            Text('${'payout.method'.tr()}: ${account['method']?.toString().toUpperCase() ?? ''}'),
            Text('${'payout.number'.tr()}: ${account['phoneNumber'] ?? ''}'),
            Text('${'payout.name'.tr()}: ${account['accountName'] ?? ''}'),
          ] else
            Text('payout.no_account_linked'.tr(), style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildPayoutAction(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'payout.amount_to_withdraw'.tr(),
            suffixText: 'FCFA',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final amt = double.tryParse(_amountController.text);
            if (amt != null && amt > 0) {
              context.read<PayoutCubit>().requestPayout(amt);
              _amountController.clear();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('payout.request_withdraw'.tr()),
        ),
      ],
    );
  }

  Widget _buildPayoutItem(BuildContext context, Map<String, dynamic> p) {
    final status = p['status'] as String? ?? 'pending';
    final amount = p['amount']?.toString() ?? '0';
    final date = DateTime.tryParse(p['createdAt'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$amount FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(DateFormat('dd MMM yyyy').format(date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          _buildStatusChip(status),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = AppTheme.statusPending;
    if (status == 'processed') color = AppTheme.successColor;
    if (status == 'rejected') color = AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.tr(),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAccountDialog(BuildContext context, Map<String, dynamic>? currentAccount) {
    final methodController = TextEditingController(text: currentAccount?['method'] ?? 'momo');
    final phoneController = TextEditingController(text: currentAccount?['phoneNumber'] ?? '');
    final nameController = TextEditingController(text: currentAccount?['accountName'] ?? '');
    final cubit = context.read<PayoutCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('payout.edit_account'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: methodController.text,
              items: const [
                DropdownMenuItem(value: 'momo', child: Text('MTN Mobile Money')),
                DropdownMenuItem(value: 'om', child: Text('Orange Money')),
              ],
              onChanged: (v) => methodController.text = v!,
              decoration: InputDecoration(labelText: 'payout.method'.tr()),
            ),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: 'payout.number'.tr())),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'payout.name'.tr())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('common.cancel'.tr())),
          ElevatedButton(
            onPressed: () {
              cubit.updateAccount(
                method: methodController.text,
                phoneNumber: phoneController.text,
                accountName: nameController.text,
              );
              Navigator.pop(context);
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }
}

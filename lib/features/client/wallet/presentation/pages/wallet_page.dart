import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/features/client/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WalletCubit>()..loadHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('wallet.title'.tr()),
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<WalletCubit>().loadHistory();
            context.read<ProfileCubit>().loadProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBalanceCard(context),
                const SizedBox(height: 32),
                _buildQuickActions(context),
                const SizedBox(height: 32),
                Text(
                  'wallet.history_title'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildTransactionHistory(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final balance = state.maybeWhen(
          loaded: (user) => user.balance ?? 0.0,
          orElse: () => 0.0,
        );

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'wallet.current_balance'.tr(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.account_balance_wallet, color: Colors.white70),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${balance.toStringAsFixed(0)} FCFA',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'wallet.safe_payment'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.add_circle_outline,
            label: 'wallet.recharge'.tr(),
            onTap: () => _showRechargeDialog(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.qr_code_scanner,
            label: 'wallet.scan'.tr(),
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('common.coming_soon'.tr())),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (history) {
            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text('wallet.no_transactions'.tr()),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tx = history[index];
                final isCredit = tx['type'] == 'recharge' || tx['type'] == 'credit';
                final amount = (tx['amount'] as num).toDouble();
                final date = DateTime.tryParse(tx['createdAt'] ?? '') ?? DateTime.now();

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isCredit
                              ? AppTheme.successColor.withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isCredit ? AppTheme.successColor : Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx['description'] ?? (isCredit ? 'Recharge' : 'Paiement commande'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('dd MMM, HH:mm').format(date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isCredit ? '+' : '-'}${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCredit ? AppTheme.successColor : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (msg) => Center(child: Text(msg)),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  void _showRechargeDialog(BuildContext context) {
    final amountController = TextEditingController();
    String method = 'orange_money';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('wallet.recharge'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'wallet.amount'.tr(),
                  suffixText: 'FCFA',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: method,
                decoration: InputDecoration(labelText: 'wallet.method'.tr()),
                items: [
                  DropdownMenuItem(value: 'orange_money', child: Text('Orange Money')),
                  DropdownMenuItem(value: 'mtn_momo', child: Text('MTN MoMo')),
                ],
                onChanged: (v) => setDialogState(() => method = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 1000;
                Navigator.pop(ctx);
                _initiateRecharge(context, amount, method);
              },
              child: Text('wallet.confirm'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initiateRecharge(BuildContext context, double amount, String method) async {
    final walletCubit = context.read<WalletCubit>();
    await walletCubit.recharge(amount, method);
    
    if (context.mounted) {
      final state = walletCubit.state;
      state.maybeWhen(
        rechargeInitiated: (url) {
           context.push('/client/payment', extra: {
              'paymentUrl': url,
              'orderId': 'recharge_${DateTime.now().millisecondsSinceEpoch}',
            });
        },
        error: (msg) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        },
        orElse: () {},
      );
    }
  }
}

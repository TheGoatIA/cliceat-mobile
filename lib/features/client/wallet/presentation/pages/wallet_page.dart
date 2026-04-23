import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/client/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WalletCubit>()..loadHistory(),
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'wallet.title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: RefreshIndicator(
          color: AppTheme.primaryRed,
          onRefresh: () async {
            context.read<WalletCubit>().loadHistory();
            context.read<ProfileCubit>().loadProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBalanceCard(context),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 28),
                Text(
                  'wallet.history_title'.tr(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppTheme.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
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
            gradient: const LinearGradient(
              colors: [AppTheme.primaryRed, AppTheme.redDeep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
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
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const Icon(Icons.account_balance_wallet,
                      color: Colors.white70),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${balance.toStringAsFixed(0)} FCFA',
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'wallet.safe_payment'.tr(),
                  style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 12),
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
            iconBg: AppTheme.greenSoft,
            iconColor: AppTheme.green,
            onTap: () => _showRechargeDialog(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.qr_code_scanner,
            label: 'wallet.scan'.tr(),
            iconBg: AppTheme.redSoft,
            iconColor: AppTheme.primaryRed,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('common.coming_soon'.tr()),
                  backgroundColor: AppTheme.ink,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
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
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.lineSoft),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppTheme.ink),
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
          loading: () => const Center(
            child: CircularProgressIndicator(
                color: AppTheme.primaryRed, strokeWidth: 2),
          ),
          loaded: (history) {
            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'wallet.no_transactions'.tr(),
                    style:
                        GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = history[index];
                final isCredit =
                    tx['type'] == 'recharge' || tx['type'] == 'credit';
                final amount = (tx['amount'] as num).toDouble();
                final date =
                    DateTime.tryParse(tx['createdAt'] ?? '') ?? DateTime.now();

                return Container(
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
                          color: isCredit
                              ? AppTheme.greenSoft
                              : AppTheme.redSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: isCredit
                              ? AppTheme.green
                              : AppTheme.primaryRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx['description'] ??
                                  (isCredit ? 'Recharge' : 'Paiement commande'),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppTheme.ink),
                            ),
                            Text(
                              DateFormat('dd MMM, HH:mm').format(date),
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isCredit ? '+' : '-'}${amount.toStringAsFixed(0)} FCFA',
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: isCredit
                              ? AppTheme.green
                              : AppTheme.primaryRed,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (msg) => Center(
            child: Text(msg,
                style: GoogleFonts.inter(
                    color: AppTheme.primaryRed, fontSize: 14)),
          ),
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
          title: Text(
            'wallet.recharge'.tr(),
            style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppTheme.ink),
          ),
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
                decoration:
                    InputDecoration(labelText: 'wallet.method'.tr()),
                items: const [
                  DropdownMenuItem(
                      value: 'orange_money', child: Text('Orange Money')),
                  DropdownMenuItem(
                      value: 'mtn_momo', child: Text('MTN MoMo')),
                ],
                onChanged: (v) => setDialogState(() => method = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('common.cancel'.tr(),
                  style: GoogleFonts.inter(color: AppTheme.muted)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount =
                    double.tryParse(amountController.text) ?? 1000;
                Navigator.pop(ctx);
                _initiateRecharge(context, amount, method);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('wallet.confirm'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initiateRecharge(
      BuildContext context, double amount, String method) async {
    final walletCubit = context.read<WalletCubit>();
    await walletCubit.recharge(amount, method);

    if (context.mounted) {
      final state = walletCubit.state;
      state.maybeWhen(
        rechargeInitiated: (url) {
          context.push('/client/payment', extra: {
            'paymentUrl': url,
            'orderId':
                'recharge_${DateTime.now().millisecondsSinceEpoch}',
          });
        },
        error: (msg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppTheme.primaryRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        orElse: () {},
      );
    }
  }
}

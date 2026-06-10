import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/client/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:cliceat_app/core/config/feature_flags.dart';
import 'package:cliceat_app/core/widgets/feature_gate.dart';
import 'package:cliceat_app/features/client/profile/presentation/bloc/profile_cubit.dart';
import 'package:cliceat_app/core/mixins/secure_screen_mixin.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SecureScreenMixin {
  late final WalletCubit _walletCubit;

  @override
  void initState() {
    super.initState();
    _walletCubit = getIt<WalletCubit>()..loadHistory();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _walletCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
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
            body: FeatureGate(
              featureKey: FeatureFlags.wallet,
              fallback: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 64,
                        color: AppTheme.muted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'wallet.feature_disabled'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              child: RefreshIndicator(
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
        },
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
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white70,
                  ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'wallet.safe_payment'.tr(),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
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
                color: AppTheme.ink,
              ),
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
              color: AppTheme.primaryRed,
              strokeWidth: 2,
            ),
          ),
          loaded: (history) {
            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.lineSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          color: AppTheme.muted,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'wallet.no_transactions'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = history[index];
                final type = tx['type']?.toString() ?? '';
                final status = tx['status']?.toString() ?? 'initiated';
                final amount = (tx['amount'] as num? ?? 0).toDouble();
                final date =
                    DateTime.tryParse(tx['createdAt']?.toString() ?? '') ??
                    DateTime.now();
                final rawDesc = tx['description']?.toString();
                final description = rawDesc ?? _fallbackDescription(type);
                final method = tx['method']?.toString() ?? '';

                final config = _txConfig(type, status);

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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: config['bgColor'] as Color,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          config['icon'] as IconData,
                          color: config['iconColor'] as Color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppTheme.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  DateFormat('dd MMM, HH:mm').format(date),
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppTheme.muted,
                                  ),
                                ),
                                if (method.isNotEmpty &&
                                    type != 'recharge') ...([
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.muted,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _methodLabel(method),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            const SizedBox(height: 6),
                            _statusBadge(status),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${config['prefix'] as String}${amount.toStringAsFixed(0)}',
                            style: GoogleFonts.bricolageGrotesque(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: config['amountColor'] as Color,
                            ),
                          ),
                          Text(
                            'FCFA',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (msg) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.primaryRed,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryRed,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Map<String, dynamic> _txConfig(String type, String status) {
    if (status == 'refunded') {
      return {
        'icon': Icons.undo_rounded,
        'bgColor': const Color(0xFFE8F5E9),
        'iconColor': const Color(0xFF2E7D32),
        'amountColor': const Color(0xFF2E7D32),
        'prefix': '+',
      };
    }
    switch (type) {
      case 'recharge':
        return {
          'icon': Icons.add_circle_rounded,
          'bgColor': const Color(0xFFE8F5E9),
          'iconColor': const Color(0xFF2E7D32),
          'amountColor': const Color(0xFF2E7D32),
          'prefix': '+',
        };
      case 'wallet_payment':
        return {
          'icon': Icons.account_balance_wallet_rounded,
          'bgColor': const Color(0xFFFFF3E0),
          'iconColor': const Color(0xFFE65100),
          'amountColor': AppTheme.primaryRed,
          'prefix': '-',
        };
      case 'refund':
        return {
          'icon': Icons.undo_rounded,
          'bgColor': const Color(0xFFE8F5E9),
          'iconColor': const Color(0xFF2E7D32),
          'amountColor': const Color(0xFF2E7D32),
          'prefix': '+',
        };
      default:
        return {
          'icon': Icons.shopping_bag_rounded,
          'bgColor': AppTheme.redSoft,
          'iconColor': AppTheme.primaryRed,
          'amountColor': AppTheme.primaryRed,
          'prefix': '-',
        };
    }
  }

  String _fallbackDescription(String type) {
    switch (type) {
      case 'recharge':
        return 'wallet.type_recharge'.tr();
      case 'wallet_payment':
        return 'wallet.type_wallet_payment'.tr();
      case 'refund':
        return 'wallet.type_refund'.tr();
      default:
        return 'wallet.type_order_payment'.tr();
    }
  }

  String _methodLabel(String method) {
    switch (method) {
      case 'orange_money':
        return 'wallet.orange_money'.tr();
      case 'mtn_momo':
        return 'wallet.mtn_momo'.tr();
      case 'wave':
        return 'Wave';
      case 'wallet':
        return 'wallet.title'.tr();
      case 'cash':
        return 'wallet.method_cash'.tr();
      default:
        return method;
    }
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case 'completed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'wallet.status_completed'.tr();
        break;
      case 'initiated':
      case 'pending':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFFF8F00);
        label = 'wallet.status_pending'.tr();
        break;
      case 'failed':
        bg = AppTheme.redSoft;
        fg = AppTheme.primaryRed;
        label = 'wallet.status_failed'.tr();
        break;
      case 'refunded':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        label = 'wallet.status_refunded'.tr();
        break;
      case 'cancelled':
        bg = AppTheme.lineSoft;
        fg = AppTheme.muted;
        label = 'wallet.status_cancelled'.tr();
        break;
      default:
        bg = AppTheme.lineSoft;
        fg = AppTheme.muted;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  void _showRechargeDialog(BuildContext pageContext) {
    final amountController = TextEditingController();
    String method = 'orange_money';

    showDialog(
      context: pageContext,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(
            'wallet.recharge'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
            ),
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
                decoration: InputDecoration(labelText: 'wallet.method'.tr()),
                items: [
                  DropdownMenuItem(
                    value: 'orange_money',
                    child: Text('wallet.orange_money'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'mtn_momo',
                    child: Text('wallet.mtn_momo'.tr()),
                  ),
                ],
                onChanged: (v) => setDialogState(() => method = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'common.cancel'.tr(),
                style: GoogleFonts.inter(color: AppTheme.muted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 1000;
                Navigator.pop(ctx);
                _initiateRecharge(pageContext, amount, method);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('wallet.confirm'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initiateRecharge(
    BuildContext pageContext,
    double amount,
    String method,
  ) async {
    final walletCubit = pageContext.read<WalletCubit>();

    final result = await walletCubit.recharge(amount, method);

    if (pageContext.mounted) {
      result.fold(
        (err) {
          ScaffoldMessenger.of(pageContext).showSnackBar(
            SnackBar(
              content: Text(err.message),
              backgroundColor: AppTheme.primaryRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        (data) async {
          await pageContext.push(
            '/client/payment',
            extra: {
              'paymentUrl': data['paymentUrl'],
              'orderId': data['reference'],
              'isWalletRecharge': true,
            },
          );
          if (pageContext.mounted) {
            pageContext.read<WalletCubit>().loadHistory();
            pageContext.read<ProfileCubit>().loadProfile();
          }
        },
      );
    }
  }
}

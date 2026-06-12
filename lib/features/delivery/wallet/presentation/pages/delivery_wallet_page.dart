import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cliceat_app/core/config/flavor_config.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

class DeliveryWalletPage extends StatefulWidget {
  const DeliveryWalletPage({super.key});

  @override
  State<DeliveryWalletPage> createState() => _DeliveryWalletPageState();
}

class _DeliveryWalletPageState extends State<DeliveryWalletPage> {
  bool _loading = true;
  String? _error;
  double _balance = 0.0;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<String?> _getToken() async {
    final storage = getIt<FlutterSecureStorage>();
    return storage.read(key: 'jwt_token');
  }

  Future<void> _loadWallet() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await _getToken();
      final uri = Uri.parse(
        '${FlavorConfig.apiBaseUrl}/api/v1/deliveryman/wallet',
      );
      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>? ?? body;
        final balance =
            (data['balance'] as num?)?.toDouble() ??
            (data['wallet']?['balance'] as num?)?.toDouble() ??
            0.0;
        final txRaw =
            data['transactions'] as List<dynamic>? ??
            data['history'] as List<dynamic>? ??
            [];
        final transactions = txRaw
            .take(20)
            .whereType<Map<String, dynamic>>()
            .toList();
        setState(() {
          _balance = balance;
          _transactions = transactions;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'legal.load_error'.tr();
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'legal.load_error'.tr();
        _loading = false;
      });
    }
  }

  Future<void> _withdraw(double amount, String phone, String operator) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse(
        '${FlavorConfig.apiBaseUrl}/api/v1/deliveryman/wallet/withdraw',
      );
      final res = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'phone': phone,
          'operator': operator,
        }),
      );
      if (!mounted) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('delivery.wallet_withdraw_success'.tr()),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        _loadWallet();
      } else {
        final body = jsonDecode(res.body) as Map<String, dynamic>?;
        final msg = body?['message']?.toString() ?? 'legal.load_error'.tr();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: AppTheme.primaryRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('legal.load_error'.tr()),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showWithdrawSheet() {
    final amountController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedOperator = 'MTN';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.lineSoft,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'delivery.wallet_withdraw'.tr(),
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
              // Amount
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'delivery.wallet_withdraw_amount'.tr(),
                  suffixText: 'XAF',
                  helperText: 'delivery.wallet_min_amount'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'delivery.wallet_withdraw_phone'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Operator choice
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setSheetState(() => selectedOperator = 'MTN'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selectedOperator == 'MTN'
                              ? const Color(0xFFFFCC00).withValues(alpha: 0.15)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedOperator == 'MTN'
                                ? const Color(0xFFFFCC00)
                                : AppTheme.lineSoft,
                            width: selectedOperator == 'MTN' ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'MTN MoMo',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: selectedOperator == 'MTN'
                                  ? const Color(0xFFE6A800)
                                  : AppTheme.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setSheetState(() => selectedOperator = 'Orange'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selectedOperator == 'Orange'
                              ? const Color(0xFFFF6600).withValues(alpha: 0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedOperator == 'Orange'
                                ? const Color(0xFFFF6600)
                                : AppTheme.lineSoft,
                            width: selectedOperator == 'Orange' ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Orange Money',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: selectedOperator == 'Orange'
                                  ? const Color(0xFFFF6600)
                                  : AppTheme.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0;
                    final phone = phoneController.text.trim();
                    if (amount < 500) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('delivery.wallet_min_amount'.tr()),
                          backgroundColor: AppTheme.primaryRed,
                        ),
                      );
                      return;
                    }
                    if (amount > _balance) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('delivery.wallet_insufficient'.tr()),
                          backgroundColor: AppTheme.primaryRed,
                        ),
                      );
                      return;
                    }
                    if (phone.isEmpty) return;
                    Navigator.pop(ctx);
                    _withdraw(amount, phone, selectedOperator);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Confirmer le retrait',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeDate(String? raw) {
    if (raw == null) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'delivery.wallet_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            )
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppTheme.primaryRed,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadWallet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('legal.retry'.tr()),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              color: AppTheme.primaryRed,
              onRefresh: _loadWallet,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBalanceCard(),
                    const SizedBox(height: 16),
                    _buildWithdrawButton(),
                    const SizedBox(height: 28),
                    Text(
                      'delivery.wallet_transactions'.tr(),
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppTheme.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTransactionList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.green, Color(0xFF1B8A3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.green.withValues(alpha: 0.35),
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
                'delivery.wallet_balance'.tr(),
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const Icon(Icons.account_balance_wallet, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${_balance.toStringAsFixed(0)} XAF',
            style: GoogleFonts.bricolageGrotesque(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _showWithdrawSheet();
        },
        icon: const Icon(Icons.mobile_friendly_rounded),
        label: Text(
          'delivery.wallet_withdraw'.tr(),
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_transactions.isEmpty) {
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
                'delivery.wallet_no_transactions'.tr(),
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.muted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        final type = tx['type']?.toString() ?? '';
        final amount = (tx['amount'] as num? ?? 0).toDouble();
        final description = tx['description']?.toString() ?? type;
        final createdAt = tx['createdAt']?.toString();
        final isCredit = type == 'credit' || type == 'earning' || amount > 0;

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
                  color: isCredit ? const Color(0xFFE8F5E9) : AppTheme.redSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isCredit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isCredit
                      ? const Color(0xFF2E7D32)
                      : AppTheme.primaryRed,
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
                    Text(
                      _relativeDate(createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${isCredit ? '+' : '-'}${amount.abs().toStringAsFixed(0)} XAF',
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: isCredit
                      ? const Color(0xFF2E7D32)
                      : AppTheme.primaryRed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

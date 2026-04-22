// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../../../../core/di/injection.dart';
import '../../data/datasources/mission_service.dart';

class ReportIssuePage extends StatefulWidget {
  final String missionId;
  const ReportIssuePage({super.key, required this.missionId});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final Logger _logger = getIt<Logger>();
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _reasons = [
    'Client absent / injoignable (Timer 5m)',
    'Adresse incorrecte ou introuvable',
    'Problème avec la commande (Restaurant)',
    'Accident / Panne mécanique',
    'Autre urgence'
  ];
  
  bool _isLoading = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          'common.report_issue_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.redSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppTheme.primaryRed),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Les signalements sont traités par notre service client en priorité.',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppTheme.inkSoft),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Motif du signalement',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 12),
                ..._reasons.map((reason) => RadioListTile<String>(
                      title: Text(
                        reason,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppTheme.ink),
                      ),
                      value: reason,
                      groupValue: _selectedReason,
                      activeColor: AppTheme.primaryRed,
                      onChanged: (value) {
                        setState(() => _selectedReason = value);
                      },
                    )),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: TextField(
                    controller: _detailsController,
                    maxLines: 4,
                    style:
                        GoogleFonts.inter(fontSize: 14, color: AppTheme.ink),
                    decoration: InputDecoration(
                      hintText: 'Détails supplémentaires...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: AppTheme.mutedLight),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                PrimaryButton(
                  text: 'Envoyer l\'alerte',
                  isLoading: _isLoading,
                  onPressed: _selectedReason != null ? () async {
                    HapticFeedback.heavyImpact();
                    setState(() => _isLoading = true);
                    try {
                      await getIt<MissionService>().reportMission(
                        widget.missionId,
                        {
                          'reason': _selectedReason,
                          'details': _detailsController.text,
                        },
                      );
                      if(mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('common.report_sent'.tr())),
                        );
                        context.pop();
                      }
                    } catch (e) {
                      _logger.e('Error reporting mission: $e');
                      if(mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('common.network_error'.tr())),
                        );
                      }
                    } finally {
                      if(mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  } : () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

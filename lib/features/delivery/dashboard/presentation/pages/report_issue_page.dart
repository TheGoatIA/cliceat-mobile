// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
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
      appBar: AppBar(
        title: Text('common.report_issue_title'.tr()),
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
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
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Les signalements sont traités par notre service client en priorité.',
                          style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Motif du signalement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ..._reasons.map((reason) => 
                  RadioListTile<String>(
                    title: Text(reason),
                    value: reason,
                    // ignore: deprecated_member_use
                    groupValue: _selectedReason,
                    activeColor: Theme.of(context).colorScheme.error,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() => _selectedReason = value);
                    },
                  )),
                const SizedBox(height: 24),
                TextField(
                  controller: _detailsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Détails supplémentaires...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

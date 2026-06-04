import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdatePage extends StatelessWidget {
  final String? message;
  final String? updateUrl;

  const ForceUpdatePage({super.key, this.message, this.updateUrl});

  @override
  Widget build(BuildContext context) {
    final isEn = context.locale.languageCode == 'en';
    final title = isEn ? 'Update Required' : 'Mise à jour requise';
    final defaultMsg = isEn
        ? 'An important update is available. Please update the app to continue using ClicEat.'
        : 'Une mise à jour importante est disponible. Veuillez mettre à jour l\'application pour continuer à utiliser ClicEat.';
    final buttonText = isEn ? 'Update Now' : 'Mettre à jour';

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppTheme.redSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.system_update_rounded,
                  size: 64,
                  color: AppTheme.primaryRed,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message != null && message!.isNotEmpty ? message! : defaultMsg,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppTheme.muted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (updateUrl != null && updateUrl!.isNotEmpty)
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      final uri = Uri.parse(updateUrl!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'legal.privacy_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _PrivacyContent(),
      ),
    );
  }
}

class _PrivacyContent extends StatelessWidget {
  const _PrivacyContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'legal.privacy_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: AppTheme.ink,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'legal.privacy_last_updated'.tr(),
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.muted),
        ),
        const SizedBox(height: 24),
        _Section(title: 'legal.privacy_s1_title'.tr(), body: 'legal.privacy_s1_body'.tr()),
        _Section(title: 'legal.privacy_s2_title'.tr(), body: 'legal.privacy_s2_body'.tr()),
        _Section(title: 'legal.privacy_s3_title'.tr(), body: 'legal.privacy_s3_body'.tr()),
        _Section(title: 'legal.privacy_s4_title'.tr(), body: 'legal.privacy_s4_body'.tr()),
        _Section(title: 'legal.privacy_s5_title'.tr(), body: 'legal.privacy_s5_body'.tr()),
        _Section(title: 'legal.privacy_s6_title'.tr(), body: 'legal.privacy_s6_body'.tr()),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppTheme.primaryRed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.inkSoft,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Page de la Politique de Confidentialité (RGPD / DPA Cameroun).
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('legal.privacy_title'.tr()),
        elevation: 0,
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
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('legal.privacy_title'.tr(),
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('legal.privacy_last_updated'.tr(),
            style: theme.textTheme.bodySmall),
        const SizedBox(height: 24),

        _Section(
          title: 'legal.privacy_s1_title'.tr(),
          body: 'legal.privacy_s1_body'.tr(),
          titleStyle: titleStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: 'legal.privacy_s2_title'.tr(),
          body: 'legal.privacy_s2_body'.tr(),
          titleStyle: titleStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: 'legal.privacy_s3_title'.tr(),
          body: 'legal.privacy_s3_body'.tr(),
          titleStyle: titleStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: 'legal.privacy_s4_title'.tr(),
          body: 'legal.privacy_s4_body'.tr(),
          titleStyle: titleStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: 'legal.privacy_s5_title'.tr(),
          body: 'legal.privacy_s5_body'.tr(),
          titleStyle: titleStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: 'legal.privacy_s6_title'.tr(),
          body: 'legal.privacy_s6_body'.tr(),
          titleStyle: titleStyle,
          bodyStyle: bodyStyle,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
    this.titleStyle,
    this.bodyStyle,
  });

  final String title;
  final String body;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          const SizedBox(height: 8),
          Text(body, style: bodyStyle),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cliceat_app/core/config/flavor_config.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _loading = true;
  String? _content;
  String? _version;
  String? _updatedAt;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = context.locale.languageCode;
      final uri = Uri.parse(
        '${FlavorConfig.apiBaseUrl}/api/v1/legal/terms?lang=$lang',
      );
      final res = await http.get(uri);
      if (!mounted) return;
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>? ?? body;
        final raw =
            data['content']?.toString() ?? data['text']?.toString() ?? '';
        // Strip HTML tags if present
        final plain = raw.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        setState(() {
          _content = plain.isNotEmpty ? plain : raw;
          _version = data['version']?.toString();
          _updatedAt =
              data['updatedAt']?.toString() ?? data['lastUpdated']?.toString();
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'legal.load_error'.tr();
          _loading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'legal.load_error'.tr();
        _loading = false;
      });
    }
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
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
          'legal.terms_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppTheme.primaryRed,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'legal.loading'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
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
                      onPressed: _loadContent,
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
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'legal.terms_title'.tr(),
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: AppTheme.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (_version != null) 'Version $_version',
                      if (_updatedAt != null)
                        '${('legal.last_updated'.tr())} ${_formatDate(_updatedAt)}',
                    ].join(' • '),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SelectableText(
                    _content ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.inkSoft,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

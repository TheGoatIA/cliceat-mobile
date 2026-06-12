import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../cubit/ai_cubit.dart';

class QualityCheckPage extends StatefulWidget {
  final String? orderId;

  const QualityCheckPage({super.key, this.orderId});

  @override
  State<QualityCheckPage> createState() => _QualityCheckPageState();
}

class _QualityCheckPageState extends State<QualityCheckPage> {
  XFile? _imageFile;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.lightImpact();
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1280,
    );
    if (picked != null) {
      setState(() => _imageFile = picked);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppTheme.primaryRed,
                ),
                title: Text(
                  'Prendre une photo',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: AppTheme.primaryRed,
                ),
                title: Text(
                  'Choisir depuis la galerie',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _analyze() async {
    if (_imageFile == null) return;
    HapticFeedback.mediumImpact();

    final bytes = await _imageFile!.readAsBytes();
    final filename = _imageFile!.name;

    if (!mounted) return;
    await context.read<AiCubit>().checkQuality(
      imageBytes: bytes,
      filename: filename,
      orderId: widget.orderId,
    );
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
          'ai.quality_title'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocConsumer<AiCubit, AiState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg.tr()),
                  backgroundColor: AppTheme.errorColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image picker
                _buildImageArea(),
                const SizedBox(height: 20),

                // Analyze button or loading
                state.maybeWhen(
                  loading: () => const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppTheme.primaryRed),
                        SizedBox(height: 12),
                        Text('Gemini analyse votre photo...'),
                      ],
                    ),
                  ),
                  orElse: () => SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _imageFile != null ? _analyze : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        disabledBackgroundColor: AppTheme.line,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'ai.analyze'.tr(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Results
                state.maybeWhen(
                  qualityResult: (scores, overall, feedback, recommendation) =>
                      _buildResultCard(
                        context,
                        scores: scores,
                        overall: overall,
                        feedback: feedback,
                        recommendation: recommendation,
                      ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageArea() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _imageFile != null ? AppTheme.primaryRed : AppTheme.line,
            width: _imageFile != null ? 2 : 1,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.redSoft,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      size: 32,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ai.quality_hint'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyer pour choisir',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.mutedLight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required Map<String, dynamic> scores,
    required int overall,
    required String feedback,
    required String recommendation,
  }) {
    final overallColor = overall >= 7
        ? AppTheme.green
        : overall >= 5
        ? AppTheme.orange
        : AppTheme.errorColor;

    final (recIcon, recLabel, recColor) = switch (recommendation) {
      'remboursement_suggéré' || 'remboursement_suggere' => (
        '🔴',
        'ai.quality_refund'.tr(),
        AppTheme.errorColor,
      ),
      'a_signaler' ||
      'à_signaler' => ('⚠️', 'ai.quality_warn'.tr(), AppTheme.orange),
      _ => ('✅', 'ai.quality_ok'.tr(), AppTheme.green),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.lineSoft),
            boxShadow: AppTheme.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall score
              Row(
                children: [
                  Text(
                    'Score global',
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppTheme.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$overall/10',
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: overallColor,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Score bars
              _buildScoreBar(
                label: 'Présentation',
                value: (scores['presentation'] as num?)?.toDouble() ?? 0,
              ).animate().slideX(begin: -0.3, duration: 400.ms),
              const SizedBox(height: 12),
              _buildScoreBar(
                label: 'Fraîcheur',
                value:
                    (scores['fraicheur'] as num?)?.toDouble() ??
                    (scores['freshness'] as num?)?.toDouble() ??
                    0,
              ).animate().slideX(begin: -0.3, delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 12),
              _buildScoreBar(
                label: 'Quantité',
                value:
                    (scores['quantite'] as num?)?.toDouble() ??
                    (scores['quantity'] as num?)?.toDouble() ??
                    0,
              ).animate().slideX(begin: -0.3, delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 20),
              const Divider(color: AppTheme.lineSoft),
              const SizedBox(height: 16),

              // Feedback
              Text(
                feedback,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.inkSoft,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 16),

              // Recommendation chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: recColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: recColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(recIcon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      recLabel,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: recColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Dispute button if refund suggested
        if (recommendation == 'remboursement_suggéré' ||
            recommendation == 'remboursement_suggere') ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                if (widget.orderId != null) {
                  context.push('/client/dispute/create/${widget.orderId}');
                }
              },
              icon: const Icon(Icons.gavel_rounded, size: 18),
              label: Text(
                'ai.open_dispute'.tr(),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScoreBar({required String label, required double value}) {
    final normalized = (value / 10).clamp(0.0, 1.0);
    final barColor = normalized >= 0.7
        ? AppTheme.green
        : normalized >= 0.5
        ? AppTheme.orange
        : AppTheme.errorColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.inkSoft,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${value.toInt()}/10',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: barColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: normalized),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (_, v, _a) => LinearProgressIndicator(
              value: v,
              backgroundColor: AppTheme.line,
              color: barColor,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }
}

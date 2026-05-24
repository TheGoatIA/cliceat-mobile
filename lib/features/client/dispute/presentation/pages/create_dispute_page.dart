import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import 'package:cliceat_app/features/client/dispute/presentation/bloc/dispute_cubit.dart';

class CreateDisputePage extends StatefulWidget {
  final String orderId;

  const CreateDisputePage({super.key, required this.orderId});

  @override
  State<CreateDisputePage> createState() => _CreateDisputePageState();
}

class _CreateDisputePageState extends State<CreateDisputePage> {
  final _descriptionController = TextEditingController();
  String _reason = 'wrong_item';
  final List<File> _images = [];
  final _picker = ImagePicker();

  final List<Map<String, String>> _reasons = [
    {'value': 'wrong_item', 'label': 'dispute.reason_wrong_item'},
    {'value': 'missing_item', 'label': 'dispute.reason_missing_item'},
    {'value': 'late_delivery', 'label': 'dispute.reason_late_delivery'},
    {'value': 'quality_issue', 'label': 'dispute.reason_quality_issue'},
    {'value': 'other', 'label': 'dispute.reason_other'},
  ];

  Future<void> _pickImage() async {
    if (_images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('dispute.max_images'.tr()),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _images.add(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DisputeCubit>(),
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'dispute.create_title'.tr(),
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.ink,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: BlocConsumer<DisputeCubit, DisputeState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('dispute.submit_success'.tr()),
                    backgroundColor: AppTheme.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
                Navigator.pop(context);
              },
              error: (msg) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg.tr()),
                    backgroundColor: AppTheme.primaryRed,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading =
                state.maybeWhen(loading: () => true, orElse: () => false);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'dispute.reason_label'.tr(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.line),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _reason,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: _reasons
                          .map((r) => DropdownMenuItem(
                                value: r['value'],
                                child: Text(
                                  r['label']!.tr(),
                                  style: GoogleFonts.inter(
                                      fontSize: 14, color: AppTheme.ink),
                                ),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _reason = v!),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'dispute.description_label'.tr(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.line),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppTheme.ink),
                      decoration: InputDecoration(
                        hintText: 'dispute.description_hint'.tr(),
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: AppTheme.mutedLight),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'dispute.evidence_label'.tr(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'dispute.evidence_hint'.tr(),
                    style: GoogleFonts.inter(
                        color: AppTheme.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  _buildImageSelection(),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              'dispute.submit'.tr(),
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSelection() {
    return Row(
      children: [
        ..._images.asMap().entries.map((entry) {
          final idx = entry.key;
          final file = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(file,
                      width: 80, height: 80, fit: BoxFit.cover),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _images.removeAt(idx)),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (_images.length < 3)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.bg,
                border: Border.all(color: AppTheme.line),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_a_photo,
                  color: AppTheme.muted, size: 24),
            ),
          ),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('dispute.description_required'.tr()),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Map frontend reasons to exact Mongoose backend enum values
    final backendReason = switch (_reason) {
      'wrong_item' => 'missing_item',
      'missing_item' => 'missing_item',
      'late_delivery' => 'delivery_delay',
      'quality_issue' => 'bad_quality',
      _ => 'other',
    };

    context.read<DisputeCubit>().submitDispute(
          orderId: widget.orderId,
          reason: backendReason,
          description: _descriptionController.text.trim(),
          images: _images,
        );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/shorts_repository.dart';

class UploadShortBottomSheet extends StatefulWidget {
  const UploadShortBottomSheet({super.key});

  @override
  State<UploadShortBottomSheet> createState() =>
      _UploadShortBottomSheetState();
}

class _UploadShortBottomSheetState extends State<UploadShortBottomSheet> {
  final _captionController = TextEditingController();
  XFile? _pickedVideo;
  int _rating = 4;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );
    if (video != null) {
      setState(() {
        _pickedVideo = video;
        _errorMessage = null;
      });
    }
  }

  Future<void> _recordVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );
    if (video != null) {
      setState(() {
        _pickedVideo = video;
        _errorMessage = null;
      });
    }
  }

  Future<void> _publish() async {
    if (_pickedVideo == null) {
      setState(() => _errorMessage = 'shorts.upload_no_video'.tr());
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final bytes = await _pickedVideo!.readAsBytes();
      final filename = _pickedVideo!.name;
      final caption = _captionController.text.trim().isEmpty
          ? null
          : _captionController.text.trim();

      // orderId is required by the API — the parent context should provide it.
      // For now we pass an empty string; a real flow would pass the orderId via constructor.
      final result = await getIt<ShortsRepository>().uploadVideo(
        '',
        bytes,
        filename,
        _rating,
        caption,
      );

      if (!mounted) return;

      result.fold(
        (err) => setState(() {
          _isUploading = false;
          _errorMessage = err.message.tr();
        }),
        (_) => Navigator.of(context).pop(),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _errorMessage = 'common.network_error'.tr();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'shorts.upload_title'.tr(),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Video picker area
            GestureDetector(
              onTap: _pickedVideo == null ? _pickVideo : null,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lineSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.lineSoft, width: 1.5),
                ),
                child: _pickedVideo != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primaryRed,
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _pickedVideo!.name,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            onPressed: _pickVideo,
                            child: Text(
                              'shorts.upload_change'.tr(),
                              style: GoogleFonts.inter(
                                color: AppTheme.primaryRed,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.video_library_outlined,
                            color: AppTheme.muted,
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'shorts.upload_pick'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Camera record option
            if (_pickedVideo == null)
              Center(
                child: TextButton.icon(
                  onPressed: _recordVideo,
                  icon: const Icon(Icons.videocam_outlined,
                      color: AppTheme.primaryRed, size: 18),
                  label: Text(
                    'shorts.upload_record'.tr(),
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryRed,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Star rating
            Text(
              'shorts.rating'.tr(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      i < _rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Caption
            Text(
              'shorts.caption'.tr(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _captionController,
              maxLength: 200,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'shorts.caption_hint'.tr(),
                hintStyle: GoogleFonts.inter(
                  color: AppTheme.muted,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.lineSoft),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.lineSoft),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppTheme.primaryRed, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Publish button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _publish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.primaryRed.withOpacity(0.6),
                ),
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'shorts.publish'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

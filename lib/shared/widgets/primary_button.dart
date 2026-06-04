import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

enum PrimaryButtonVariant { primary, ghost, honey, dark, white }

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final PrimaryButtonVariant variant;
  final Widget? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = PrimaryButtonVariant.primary,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bg = switch (variant) {
      PrimaryButtonVariant.primary => AppTheme.primaryRed,
      PrimaryButtonVariant.ghost => Colors.transparent,
      PrimaryButtonVariant.honey => AppTheme.honey,
      PrimaryButtonVariant.dark => AppTheme.ink,
      PrimaryButtonVariant.white => Colors.white,
    };
    final fg = switch (variant) {
      PrimaryButtonVariant.primary => Colors.white,
      PrimaryButtonVariant.ghost => AppTheme.primaryRed,
      PrimaryButtonVariant.honey => AppTheme.ink,
      PrimaryButtonVariant.dark => Colors.white,
      PrimaryButtonVariant.white => AppTheme.ink,
    };
    final border = variant == PrimaryButtonVariant.ghost
        ? BorderSide(color: AppTheme.primaryRed, width: 1.5)
        : BorderSide.none;

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          side: border,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

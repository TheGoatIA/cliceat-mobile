import 'package:flutter/material.dart';

/// Centered empty-state widget with an optional illustration, message, and CTA.
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Local asset path (e.g. 'assets/images/empty_cart.png').
  /// Falls back to [icon] or a generic inbox icon.
  final String? imagePath;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIllustration(theme),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        height: 160,
        errorBuilder: (_, __, ___) => _iconFallback(theme),
      );
    }
    return _iconFallback(theme);
  }

  Widget _iconFallback(ThemeData theme) => Icon(
        icon ?? Icons.inbox_outlined,
        size: 88,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
      );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

/// Widget d'image réseau avec :
/// - Cache via `cached_network_image`
/// - Placeholder BlurHash pendant le chargement
/// - Fallback icône en cas d'erreur
/// - Taille normalisée pour éviter les re-layouts
///
/// Usage :
/// ```dart
/// AppNetworkImage(
///   url: restaurant.imageUrl,
///   width: 80,
///   height: 80,
///   fit: BoxFit.cover,
///   blurHash: restaurant.blurHash,
/// )
/// ```
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.blurHash,
    this.borderRadius,
    this.errorIcon = Icons.broken_image_outlined,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? blurHash;
  final BorderRadius? borderRadius;
  final IconData errorIcon;

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = url ?? '';

    Widget image;

    if (effectiveUrl.isEmpty) {
      image = _buildError(context);
    } else {
      image = CachedNetworkImage(
        imageUrl: effectiveUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => blurHash != null
            ? BlurHash(
                hash: blurHash!,
                imageFit: fit,
              )
            : _buildPlaceholder(context),
        errorWidget: (context, url, error) => _buildError(context),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: SizedBox(width: width, height: height, child: image),
      );
    }

    return SizedBox(width: width, height: height, child: image);
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        errorIcon,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        size: (width ?? 48) * 0.4,
      ),
    );
  }
}

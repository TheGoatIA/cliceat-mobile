import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Wraps [CachedNetworkImage] with a shimmer placeholder and a local-asset
/// fallback so every image in the app looks consistent.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackAsset;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset = 'assets/images/restaurant_placeholder.jpg',
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (url != null && url!.isNotEmpty && url!.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => _shimmer(context),
        errorWidget: (_, _, _) => _fallback(context),
      );
    } else {
      image = _fallback(context);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _shimmer(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _fallback(BuildContext context) {
    return Image.asset(
      fallbackAsset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => Container(
        width: width,
        height: height,
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.restaurant,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          size: 40,
        ),
      ),
    );
  }
}

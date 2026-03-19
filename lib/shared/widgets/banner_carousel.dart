import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/models/coupon_model.dart';

/// Auto-paging promotional banner carousel.
/// Falls back to a local asset banner when the [banners] list is empty.
class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final double height;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 160,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentPage = 0;
  final _controller = PageController();

  static final _fallback = [
    BannerModel(
      id: 'local_promo',
      imageUrl: 'assets/images/banner_promo.jpg',
      title: 'Livraison Gratuite sur votre 1ère commande',
    ),
  ];

  List<BannerModel> get _banners =>
      widget.banners.isEmpty ? _fallback : widget.banners;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _BannerItem(
              banner: _banners[i],
              height: widget.height,
            ),
          ),
        ),
        if (_banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentPage ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _currentPage
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  final BannerModel banner;
  final double height;

  const _BannerItem({required this.banner, required this.height});

  @override
  Widget build(BuildContext context) {
    final isAsset = !banner.imageUrl.startsWith('http');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          isAsset
              ? Image.asset(
                  banner.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _colorFallback(context),
                )
              : CachedNetworkImage(
                  imageUrl: banner.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => _colorFallback(context),
                  errorWidget: (_, _, _) => _colorFallback(context),
                ),

          // Gradient overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),

          // Title
          if (banner.title != null && banner.title!.isNotEmpty)
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Text(
                banner.title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _colorFallback(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.local_offer_outlined,
          size: 52,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

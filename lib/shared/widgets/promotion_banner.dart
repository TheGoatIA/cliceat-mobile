import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PromotionBanner extends StatelessWidget {
  final List<Map<String, dynamic>> promotions;
  final Function(Map<String, dynamic>)? onTap;

  const PromotionBanner({super.key, required this.promotions, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: promotions.length,
        controller: PageController(viewportFraction: 0.92),
        itemBuilder: (context, index) {
          final promo = promotions[index];
          final imageUrl = promo['imageUrl'] as String?;
          final title = promo['title'] as String? ?? '';
          final subtitle = promo['description'] as String? ?? '';

          return GestureDetector(
            onTap: () => onTap?.call(promo),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: Colors.grey.shade200),
                      errorWidget: (_, _, _) => Container(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    Container(color: Theme.of(context).colorScheme.primary),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  // Text content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

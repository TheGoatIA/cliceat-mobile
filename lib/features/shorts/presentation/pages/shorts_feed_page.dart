import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/video_review_model.dart';
import '../bloc/shorts_cubit.dart';
import '../widgets/upload_short_bottom_sheet.dart';

class ShortsFeedPage extends StatefulWidget {
  const ShortsFeedPage({super.key});

  @override
  State<ShortsFeedPage> createState() => _ShortsFeedPageState();
}

class _ShortsFeedPageState extends State<ShortsFeedPage> {
  String? _selectedCity;
  final List<String> _cities = ['Douala', 'Yaoundé'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShortsCubit>()..loadFeed(_selectedCity),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // City filter chips
                SafeArea(
                  bottom: false,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'shorts.title'.tr(),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        ..._cities.map(
                          (city) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _CityChip(
                              label: city,
                              isSelected: _selectedCity == city,
                              onTap: () {
                                setState(() {
                                  _selectedCity =
                                      _selectedCity == city ? null : city;
                                });
                                context
                                    .read<ShortsCubit>()
                                    .loadFeed(_selectedCity);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Feed
                Expanded(
                  child: BlocBuilder<ShortsCubit, ShortsState>(
                    builder: (context, state) {
                      return state.when(
                        idle: () => const SizedBox.shrink(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        loaded: (videos, hasMore) {
                          if (videos.isEmpty) {
                            return Center(
                              child: Text(
                                'shorts.empty'.tr(),
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }
                          return _ShortsPageView(
                            videos: videos,
                            hasMore: hasMore,
                            onLoadMore: () =>
                                context.read<ShortsCubit>().loadMore(),
                            onLike: (id) =>
                                context.read<ShortsCubit>().toggleLike(id),
                          );
                        },
                        error: (message) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.tr(),
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () => context
                                    .read<ShortsCubit>()
                                    .loadFeed(_selectedCity),
                                child: Text(
                                  'common.retry'.tr(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppTheme.primaryRed,
              onPressed: () => _showUpload(context),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  void _showUpload(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UploadShortBottomSheet(),
    );
  }
}

class _CityChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed : Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── PageView ────────────────────────────────────────────────────────────────

class _ShortsPageView extends StatefulWidget {
  final List<VideoReviewModel> videos;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final void Function(String id) onLike;

  const _ShortsPageView({
    required this.videos,
    required this.hasMore,
    required this.onLoadMore,
    required this.onLike,
  });

  @override
  State<_ShortsPageView> createState() => _ShortsPageViewState();
}

class _ShortsPageViewState extends State<_ShortsPageView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      itemCount: widget.videos.length,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
        if (index >= widget.videos.length - 2 && widget.hasMore) {
          widget.onLoadMore();
        }
      },
      itemBuilder: (context, index) {
        return _ShortItem(
          video: widget.videos[index],
          isActive: index == _currentPage,
          onLike: widget.onLike,
        );
      },
    );
  }
}

// ── Single Short Item ────────────────────────────────────────────────────────

class _ShortItem extends StatefulWidget {
  final VideoReviewModel video;
  final bool isActive;
  final void Function(String id) onLike;

  const _ShortItem({
    required this.video,
    required this.isActive,
    required this.onLike,
  });

  @override
  State<_ShortItem> createState() => _ShortItemState();
}

class _ShortItemState extends State<_ShortItem> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );
    await _controller!.initialize();
    _controller!.setLooping(true);
    if (mounted) {
      setState(() => _initialized = true);
      if (widget.isActive) {
        _controller!.play();
      }
    }
  }

  @override
  void didUpdateWidget(_ShortItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller?.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller?.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video background
        if (_initialized && _controller != null)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          )
        else if (widget.video.thumbnailUrl != null)
          Image.network(
            widget.video.thumbnailUrl!,
            fit: BoxFit.cover,
          )
        else
          Container(color: Colors.black87),

        // Dark gradient overlay
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
              stops: [0.5, 1.0],
            ),
          ),
        ),

        // Bottom-left: restaurant info + caption + rating
        Positioned(
          left: 16,
          bottom: 80,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.video.restaurant != null) ...[
                Text(
                  widget.video.restaurant!['name']?.toString() ?? '',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],
              if (widget.video.caption != null &&
                  widget.video.caption!.isNotEmpty) ...[
                Text(
                  widget.video.caption!,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
              ],
              _StarRating(rating: widget.video.rating),
            ],
          ),
        ),

        // Right side: actions
        Positioned(
          right: 12,
          bottom: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: widget.video.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.video.isLiked ? Colors.red : Colors.white,
                label: '${widget.video.likesCount}',
                onTap: () => widget.onLike(widget.video.id),
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.remove_red_eye_outlined,
                color: Colors.white,
                label: '${widget.video.views}',
                onTap: null,
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.share_outlined,
                color: Colors.white,
                label: 'shorts.share'.tr(),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

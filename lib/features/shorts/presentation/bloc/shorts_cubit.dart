import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:cliceat_app/features/shorts/data/models/video_review_model.dart';
import 'package:cliceat_app/features/shorts/data/repositories/shorts_repository.dart';

part 'shorts_state.dart';
part 'shorts_cubit.freezed.dart';

@injectable
class ShortsCubit extends Cubit<ShortsState> {
  final ShortsRepository _repository;

  ShortsCubit(this._repository) : super(const ShortsState.idle());

  String? _currentCity;
  int _currentPage = 1;
  List<VideoReviewModel> _videos = [];

  Future<void> loadFeed([String? city]) async {
    _currentCity = city;
    _currentPage = 1;
    _videos = [];
    emit(const ShortsState.loading());
    final result = await _repository.getFeed(city: city, page: 1);
    result.fold(
      (err) => emit(ShortsState.error(err.message)),
      (videos) {
        _videos = videos;
        emit(ShortsState.loaded(videos: videos, hasMore: videos.length >= 10));
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! _Loaded || !current.hasMore) return;
    _currentPage++;
    final result =
        await _repository.getFeed(city: _currentCity, page: _currentPage);
    result.fold(
      (err) => emit(ShortsState.error(err.message)),
      (newVideos) {
        _videos = [..._videos, ...newVideos];
        emit(ShortsState.loaded(
            videos: _videos, hasMore: newVideos.length >= 10));
      },
    );
  }

  Future<void> toggleLike(String id) async {
    final current = state;
    if (current is! _Loaded) return;

    final idx = current.videos.indexWhere((v) => v.id == id);
    if (idx == -1) return;

    final video = current.videos[idx];
    final wasLiked = video.isLiked;

    // Optimistic update
    final updated = List<VideoReviewModel>.from(current.videos);
    updated[idx] = video.copyWith(
      isLiked: !wasLiked,
      likesCount: wasLiked ? video.likesCount - 1 : video.likesCount + 1,
    );
    _videos = updated;
    emit(ShortsState.loaded(videos: updated, hasMore: current.hasMore));

    // Call API
    await _repository.likeShort(id);
  }

  Future<void> uploadVideo(
    String orderId,
    List<int> bytes,
    String filename,
    int rating,
    String? caption,
  ) async {
    await _repository.uploadVideo(orderId, bytes, filename, rating, caption);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/review_repository.dart';
import 'review_state.dart';

@injectable
class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _repository;

  ReviewCubit(this._repository) : super(const ReviewState.initial());

  Future<void> loadRestaurantReviews(String restaurantId) async {
    emit(const ReviewState.loading());
    final res = await _repository.getRestaurantReviews(restaurantId);
    res.fold(
      (err) => emit(ReviewState.error(err.message)),
      (reviews) => emit(ReviewState.loaded(reviews: reviews)),
    );
  }

  Future<void> loadMyReviews() async {
    emit(const ReviewState.loading());
    final res = await _repository.getMyReviews();
    res.fold(
      (err) => emit(ReviewState.error(err.message)),
      (reviews) => emit(ReviewState.loaded(reviews: reviews)),
    );
  }

  Future<void> submitReview({
    required String orderId,
    required String restaurantId,
    required int restaurantRating,
    int? deliveryRating,
    String? comment,
  }) async {
    emit(const ReviewState.loading());
    final res = await _repository.createReview(
      orderId: orderId,
      restaurantId: restaurantId,
      restaurantRating: restaurantRating,
      deliveryRating: deliveryRating,
      comment: comment,
    );
    res.fold(
      (err) => emit(ReviewState.error(err.message)),
      (_) => emit(const ReviewState.created()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cliceat_app/core/di/injection.dart';
import '../../../review/presentation/cubit/review_cubit.dart';
import '../../../review/presentation/cubit/review_state.dart';

class RestaurantReviewsList extends StatelessWidget {
  final String restaurantId;

  const RestaurantReviewsList({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReviewCubit>()..loadRestaurantReviews(restaurantId),
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
            loaded: (reviews) {
              if (reviews.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text('review.no_reviews_yet'.tr(), style: const TextStyle(color: Colors.grey)),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.clientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              timeago.format(review.createdAt, locale: context.locale.languageCode),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < review.restaurantRating 
                                  ? Icons.star 
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16.0,
                            );
                          }),
                        ),
                        if (review.comment != null && review.comment!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(review.comment!),
                        ]
                      ],
                    ),
                  );
                },
              );
            },
            error: (msg) => Center(child: Text(msg, style: const TextStyle(color: Colors.red))),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cliceat_app/core/di/injection.dart';
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../../../review/presentation/cubit/review_cubit.dart';
import '../../../review/presentation/cubit/review_state.dart';

class RestaurantReviewsList extends StatelessWidget {
  final String restaurantId;

  const RestaurantReviewsList({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ReviewCubit>()..loadRestaurantReviews(restaurantId),
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
                child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryRed, strokeWidth: 2))),
            loaded: (reviews) {
              if (reviews.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text('review.no_reviews_yet'.tr(),
                        style:
                            GoogleFonts.inter(color: AppTheme.muted, fontSize: 14)),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: AppTheme.lineSoft, height: 1),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.clientName,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppTheme.ink)),
                            Text(
                              timeago.format(review.createdAt,
                                  locale: context.locale.languageCode),
                              style: GoogleFonts.inter(
                                  color: AppTheme.muted, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < review.restaurantRating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: starIndex < review.restaurantRating
                                  ? AppTheme.honey
                                  : AppTheme.lineSoft,
                              size: 16.0,
                            );
                          }),
                        ),
                        if (review.comment != null &&
                            review.comment!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(review.comment!,
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: AppTheme.inkSoft)),
                        ]
                      ],
                    ),
                  );
                },
              );
            },
            error: (msg) => Center(
                child: Text(msg,
                    style: GoogleFonts.inter(
                        color: AppTheme.errorColor, fontSize: 14))),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

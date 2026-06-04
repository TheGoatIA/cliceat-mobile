import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cliceat_app/core/theme/app_theme.dart';
import '../cubit/review_cubit.dart';
import '../cubit/review_state.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'review.my_reviews'.tr(),
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.ink,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            ),
            loaded: (reviews) {
              if (reviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.bgWarm,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.rate_review_outlined,
                          size: 36,
                          color: AppTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'review.no_reviews_yet'.tr(),
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Commandez et notez vos restaurants',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppTheme.muted),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.lineSoft),
                      boxShadow: AppTheme.shadowSm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                review.restaurantName ?? 'Restaurant',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppTheme.ink,
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              timeago.format(
                                review.createdAt,
                                locale: context.locale.languageCode,
                              ),
                              style: GoogleFonts.inter(
                                color: AppTheme.mutedLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < review.restaurantRating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: AppTheme.honey,
                              size: 18,
                            );
                          }),
                        ),
                        if (review.comment != null &&
                            review.comment!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            review.comment!,
                            style: GoogleFonts.inter(
                              color: AppTheme.inkSoft,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                        if (review.restaurantResponse != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.bg,
                              borderRadius: BorderRadius.circular(10),
                              border: const Border(
                                left: BorderSide(
                                  color: AppTheme.primaryRed,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'review.restaurant_reply'.tr(),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppTheme.primaryRed,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  review.restaurantResponse!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppTheme.inkSoft,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            },
            error: (msg) => Center(
              child: Text(
                msg,
                style: GoogleFonts.inter(
                    color: AppTheme.primaryRed, fontSize: 14),
              ),
            ),
            orElse: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}

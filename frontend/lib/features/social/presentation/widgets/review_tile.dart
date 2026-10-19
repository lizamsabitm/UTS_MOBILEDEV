import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/data/review_model.dart';
import 'review_actions_bar.dart';

class SocialReviewTile extends StatelessWidget {
  final ReviewModel review;
  final bool showAuthor;
  final VoidCallback? onAuthorTap;

  const SocialReviewTile({
    Key? key,
    required this.review,
    this.showAuthor = false,
    this.onAuthorTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 64,
            height: 96,
            child: Image.network(
              review.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2C3946)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.movieTitle ?? 'Film Review',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showAuthor) ...[
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: onAuthorTap,
                  child: Text(
                    'Reviewed by @${review.username}',
                    style: const TextStyle(color: AppTheme.accentBlue, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: List.generate(5, (i) {
                  final filled = review.rating >= (i + 1);
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: filled ? const Color(0xFF00E054) : const Color(0xFF33414E),
                  );
                }),
              ),
              if (review.content.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  review.content,
                  style: const TextStyle(color: Color(0xFFBAC6D0), fontSize: 13, height: 1.4),
                ),
              ],
              const SizedBox(height: 8),
              ReviewActionsBar(
                key: ValueKey('tile-${review.id}'),
                reviewId: review.id,
                initialLiked: review.likedByMe,
                initialLikeCount: review.likeCount,
                initialCommentCount: review.commentCount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
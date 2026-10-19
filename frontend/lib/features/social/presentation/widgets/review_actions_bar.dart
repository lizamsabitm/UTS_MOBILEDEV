import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/social_service.dart';
import 'comments_sheet.dart';

class ReviewActionsBar extends StatefulWidget {
  final int reviewId;
  final bool initialLiked;
  final int initialLikeCount;
  final int initialCommentCount;

  const ReviewActionsBar({
    Key? key,
    required this.reviewId,
    required this.initialLiked,
    required this.initialLikeCount,
    required this.initialCommentCount,
  }) : super(key: key);

  @override
  State<ReviewActionsBar> createState() => _ReviewActionsBarState();
}

class _ReviewActionsBarState extends State<ReviewActionsBar> {
  final SocialService _service = SocialService();
  late bool _liked;
  late int _likeCount;
  late int _commentCount;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _liked = widget.initialLiked;
    _likeCount = widget.initialLikeCount;
    _commentCount = widget.initialCommentCount;
  }

  Future<void> _toggleLike() async {
    if (_busy) return;
    final wasLiked = _liked;
    final prevCount = _likeCount;
    setState(() {
      _busy = true;
      _liked = !wasLiked;
      _likeCount = prevCount + (wasLiked ? -1 : 1);
    });
    try {
      final serverCount = wasLiked
          ? await _service.unlikeReview(widget.reviewId)
          : await _service.likeReview(widget.reviewId);
      if (mounted) setState(() => _likeCount = serverCount);
    } catch (e) {
      if (mounted) {
        setState(() {
          _liked = wasLiked;
          _likeCount = prevCount;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _openComments() {
    CommentsSheet.show(
      context,
      reviewId: widget.reviewId,
      onCountChanged: (count) {
        if (mounted) setState(() => _commentCount = count);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final likeColor = _liked ? const Color(0xFFFF8000) : AppTheme.textSecondary;
    return Row(
      children: [
        InkWell(
          onTap: _toggleLike,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Icon(_liked ? Icons.favorite : Icons.favorite_border, size: 18, color: likeColor),
                const SizedBox(width: 4),
                Text('$_likeCount', style: TextStyle(color: likeColor, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        InkWell(
          onTap: _openComments,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 17, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '$_commentCount',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
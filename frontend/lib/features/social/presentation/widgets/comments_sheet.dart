import 'package:flutter/material.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../data/social_models.dart';
import '../../data/social_service.dart';

class CommentsSheet extends StatefulWidget {
  final int reviewId;
  final ValueChanged<int>? onCountChanged;

  const CommentsSheet({Key? key, required this.reviewId, this.onCountChanged}) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required int reviewId,
    ValueChanged<int>? onCountChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CommentsSheet(reviewId: reviewId, onCountChanged: onCountChanged),
    );
  }

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final SocialService _service = SocialService();
  final TextEditingController _controller = TextEditingController();
  List<ReviewComment> _comments = [];
  bool _loading = true;
  bool _sending = false;
  String? _error;
  int? _myId;

  @override
  void initState() {
    super.initState();
    TokenStorage.getUserId().then((id) {
      if (mounted) setState(() => _myId = id);
    });
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snack(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _service.fetchComments(widget.reviewId);
      if (!mounted) return;
      setState(() {
        _comments = list;
        _loading = false;
      });
      widget.onCountChanged?.call(list.length);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e);
        _loading = false;
      });
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final comment = await _service.addComment(widget.reviewId, text);
      if (!mounted) return;
      _controller.clear();
      setState(() => _comments = [..._comments, comment]);
      widget.onCountChanged?.call(_comments.length);
    } catch (e) {
      _snack(e);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _delete(ReviewComment comment) async {
    try {
      await _service.deleteComment(widget.reviewId, comment.id);
      if (!mounted) return;
      setState(() => _comments = _comments.where((c) => c.id != comment.id).toList());
      widget.onCountChanged?.call(_comments.length);
    } catch (e) {
      _snack(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Text(
              'Comments',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(color: AppTheme.divider, height: 1),
            Expanded(child: _buildList()),
            const Divider(color: AppTheme.divider, height: 1),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLength: 191,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: AppTheme.textSecondary),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    IconButton(
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.accentGreen,
                              ),
                            )
                          : const Icon(Icons.send, color: AppTheme.accentGreen),
                      onPressed: _sending ? null : _send,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_loading) return const LoadingState(message: 'Loading comments...');
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_comments.isEmpty) return const EmptyState(message: 'No comments yet. Be the first!');

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      itemCount: _comments.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFF242E37), height: 20),
      itemBuilder: (context, index) {
        final c = _comments[index];
        final initial = c.displayName.isNotEmpty ? c.displayName[0].toUpperCase() : 'U';
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF2C3946),
              child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.displayName,
                    style: const TextStyle(
                      color: Color(0xFFBAC6D0),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    c.content,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.35),
                  ),
                ],
              ),
            ),
            if (_myId != null && c.userId == _myId)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.textSecondary),
                onPressed: () => _delete(c),
              ),
          ],
        );
      },
    );
  }
}
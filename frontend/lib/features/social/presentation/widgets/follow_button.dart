import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/social_service.dart';

class FollowButton extends StatefulWidget {
  final int userId;
  final bool initialFollowing;
  final ValueChanged<bool>? onChanged;

  const FollowButton({
    Key? key,
    required this.userId,
    required this.initialFollowing,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  final SocialService _service = SocialService();
  late bool _following;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _following = widget.initialFollowing;
  }

  Future<void> _toggle() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (_following) {
        await _service.unfollow(widget.userId);
      } else {
        await _service.follow(widget.userId);
      }
      if (!mounted) return;
      setState(() => _following = !_following);
      widget.onChanged?.call(_following);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: _following
          ? OutlinedButton(
              onPressed: _busy ? null : _toggle,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: const BorderSide(color: AppTheme.divider),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: const Text('Following', style: TextStyle(fontSize: 13)),
            )
          : ElevatedButton(
              onPressed: _busy ? null : _toggle,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: const Text(
                'Follow',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
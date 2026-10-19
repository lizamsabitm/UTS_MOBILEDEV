import 'package:flutter/material.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../data/social_models.dart';
import '../data/social_service.dart';
import 'user_profile_screen.dart';
import 'widgets/follow_button.dart';

enum FollowListType { followers, following }

class FollowListScreen extends StatefulWidget {
  final int userId;
  final FollowListType type;

  const FollowListScreen({Key? key, required this.userId, required this.type}) : super(key: key);

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  final SocialService _service = SocialService();
  List<SocialUser> _users = [];
  bool _loading = true;
  String? _error;
  int? _myId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final myId = await TokenStorage.getUserId();
      final users = widget.type == FollowListType.followers
          ? await _service.fetchFollowers(widget.userId)
          : await _service.fetchFollowing(widget.userId);
      if (!mounted) return;
      setState(() {
        _myId = myId;
        _users = users;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == FollowListType.followers ? 'Followers' : 'Following';
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(title)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingState();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_users.isEmpty) {
      return EmptyState(
        message: widget.type == FollowListType.followers
            ? 'No followers yet.'
            : 'Not following anyone yet.',
      );
    }

    return ListView.separated(
      itemCount: _users.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFF242E37), height: 1),
      itemBuilder: (context, index) {
        final user = _users[index];
        final initial = user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'U';
        return ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => UserProfileScreen(userId: user.id)),
          ),
          leading: CircleAvatar(
            backgroundColor: AppTheme.accentGreen,
            child: Text(
              initial,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(user.displayName, style: const TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text(
            '@${user.username}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          trailing: (_myId != null && user.id == _myId)
              ? null
              : FollowButton(
                  key: ValueKey('list-follow-${user.id}'),
                  userId: user.id,
                  initialFollowing: user.isFollowing,
                  onChanged: (value) => user.isFollowing = value,
                ),
        );
      },
    );
  }
}
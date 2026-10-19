import 'package:flutter/material.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../data/social_models.dart';
import '../data/social_service.dart';
import 'follow_list_screen.dart';
import 'widgets/follow_button.dart';
import 'widgets/review_tile.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final SocialService _service = SocialService();
  PublicProfile? _profile;
  int? _myId;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool showSpinner = true}) async {
    if (showSpinner) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final myId = await TokenStorage.getUserId();
      final profile = await _service.fetchPublicProfile(widget.userId);
      if (!mounted) return;
      setState(() {
        _myId = myId;
        _profile = profile;
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

  void _openList(FollowListType type) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FollowListScreen(userId: widget.userId, type: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _profile;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(p != null ? '@${p.username}' : 'Profile')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingState();
    final p = _profile;
    if (_error != null || p == null) {
      return ErrorState(message: _error ?? 'Profil tidak ditemukan.', onRetry: () => _load());
    }

    final initial = p.displayName.isNotEmpty ? p.displayName[0].toUpperCase() : 'U';
    return RefreshIndicator(
      color: AppTheme.accentGreen,
      backgroundColor: AppTheme.surface,
      onRefresh: () => _load(showSpinner: false),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.accentGreen,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              p.displayName,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              '@${p.username}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat('Reviews', p.reviewCount, null),
              _stat('Followers', p.followerCount, () => _openList(FollowListType.followers)),
              _stat('Following', p.followingCount, () => _openList(FollowListType.following)),
            ],
          ),
          const SizedBox(height: 16),
          if (_myId != p.id)
            Center(
              child: FollowButton(
                key: ValueKey('profile-follow-${p.id}'),
                userId: p.id,
                initialFollowing: p.isFollowing,
                onChanged: (_) => _load(showSpinner: false),
              ),
            ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF242E37), height: 1),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              'REVIEWS',
              style: TextStyle(
                color: Color(0xFF677785),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          if (p.reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No reviews yet.',
                  style: TextStyle(color: Color(0xFF677785), fontSize: 14),
                ),
              ),
            )
          else
            ...p.reviews.map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: SocialReviewTile(review: r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
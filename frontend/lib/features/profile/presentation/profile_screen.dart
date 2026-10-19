import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../home/presentation/movie_detail_screen.dart';
import '../../home/presentation/widgets/movie_poster_card.dart';
import '../data/user_profile_model.dart';
import '../data/user_service.dart';
import 'profile_settings_screen.dart';
import '../../social/presentation/follow_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _userService.fetchProfile();
      if (mounted) {
        setState(() {
          // If backend returns profile, use it; otherwise provide default matching screenshot
          _profile = profile ??
              UserProfile(
                id: 1,
                name: 'Maman',
                username: 'maman12345',
                email: 'abdurrahman.jibrinn@gmail.com',
                watchlist: [],
                reviews: [],
              );
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _profile = UserProfile(
            id: 1,
            name: 'Maman',
            username: 'maman12345',
            email: 'abdurrahman.jibrinn@gmail.com',
            watchlist: [],
            reviews: [],
          );
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openSettings() async {
    final username = _profile?.username ?? 'maman12345';
    final email = _profile?.email ?? 'abdurrahman.jibrinn@gmail.com';
    final name = _profile?.name ?? '';
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProfileSettingsScreen(
          username: username,
          email: email,
          name: name,
        ),
      ),
    );
    if (result == true) {
      _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.accentGreen),
        ),
      );
    }

    final user = _profile ??
        UserProfile(
          id: 1,
          name: 'Maman',
          username: 'maman12345',
          email: 'abdurrahman.jibrinn@gmail.com',
          watchlist: [],
          reviews: [],
        );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.headerBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
            tooltip: 'Settings',
            onPressed: _openSettings,
          ),
          centerTitle: true,
          title: Text(
            user.username,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
              tooltip: 'More',
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppTheme.accentGreen,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Diary'),
              Tab(text: 'Lists'),
              Tab(text: 'Watchlist'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfileTab(user),
            _buildDiaryTab(),
            _buildListsTab(),
            _buildWatchlistTab(user),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(UserProfile user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Circular Avatar (Screenshot 193113 style)
          const Center(
            child: CircleAvatar(
              radius: 46,
              backgroundColor: Color(0xFF2C3946),
              backgroundImage: AssetImage('assets/icons/app_icon.png'),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF242E37), height: 1),

          // RATINGS Section (Histogram)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RATINGS',
                  style: TextStyle(
                    color: Color(0xFF677785),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFF00E054), size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: const Color(0xFF242E37),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Color(0xFF00E054),
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF242E37), height: 1),

          // Itemized list with counts
          _buildItemRow('Films', user.reviews.length.toString()),
          _buildItemRow('Diary', '0'),
          _buildItemRow('Reviews', user.reviews.length.toString()),
          _buildItemRow('Watchlist', user.watchlist.length.toString()),
          _buildItemRow('Lists', '0'),
          _buildItemRow('Likes', user.likeCount.toString()),
          _buildItemRow('Tags', '0'),
                    _buildItemRow(
            'Following',
            user.followingCount.toString(),
            onTap: () => _openFollowList(user, FollowListType.following),
          ),
          _buildItemRow(
            'Followers',
            user.followerCount.toString(),
            onTap: () => _openFollowList(user, FollowListType.followers),
          ),
          _buildItemRow('Stats', null, hasProBadge: true),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

    Future<void> _openFollowList(UserProfile user, FollowListType type) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FollowListScreen(userId: user.id, type: type)),
    );
    if (mounted) _loadProfile(); // jumlah following/followers bisa berubah
  }

  Widget _buildItemRow(
    String title,
    String? count, {
    bool hasProBadge = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF1E252C), width: 1),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFBAC6D0),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (count != null) ...[
              Text(
                count,
                style: const TextStyle(
                  color: Color(0xFF677785),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (hasProBadge) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8000),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF677785),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaryTab() {
    return const Center(
      child: Text(
        'No diary entries yet.',
        style: TextStyle(color: Color(0xFF677785), fontSize: 14),
      ),
    );
  }

  Widget _buildListsTab() {
    return Stack(
      children: [
        const Center(
          child: Text(
            'You haven\'t created any lists yet.',
            style: TextStyle(color: Color(0xFF677785), fontSize: 14),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF00E054),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create List modal')),
              );
            },
            child: const Icon(Icons.add, color: Colors.black, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildWatchlistTab(UserProfile user) {
    if (user.watchlist.isEmpty) {
      return const EmptyState(
        message: 'Your watchlist is empty. Add movies you want to watch!',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: user.watchlist.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        final movie = user.watchlist[index];
        return MoviePosterCard(
          movie: movie,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: movie),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../home/data/review_model.dart';
import '../../social/data/social_service.dart';
import '../../social/presentation/user_profile_screen.dart';
import '../../social/presentation/widgets/review_tile.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> {
  final SocialService _service = SocialService();
  List<ReviewModel> _friends = [];
  List<ReviewModel> _mine = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    reload();
  }

  /// [silent] = true: jangan tampilkan spinner layar penuh (dipakai saat pindah tab / tarik-refresh).
  Future<void> reload({bool silent = false}) async {
    if (!mounted) return;
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final results = await Future.wait([
        _service.fetchFeed(),
        _service.fetchMyReviews(),
      ]);
      if (!mounted) return;
      setState(() {
        _friends = results[0];
        _mine = results[1];
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      if (!silent) {
        setState(() {
          _error = friendlyError(e);
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.headerBackground,
          elevation: 0,
          title: const Text(
            'Activity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppTheme.textSecondary),
              tooltip: 'Filter',
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
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'Friends'),
              Tab(text: 'You'),
              Tab(text: 'Incoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReviewList(
              items: _friends,
              showAuthor: true,
              emptyQuote:
                  'No activity from friends yet.\n\nFollow members from Search > Members to see their reviews here.',
            ),
            _buildReviewList(
              items: _mine,
              showAuthor: false,
              emptyQuote:
                  'No recent activity.\n\nWhen you log, review, or like films, your activity will show up here.',
            ),
            _buildEmptyState(
              quote:
                  'No incoming notifications.\n\nMentions, followers, and comments will appear here.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList({
    required List<ReviewModel> items,
    required bool showAuthor,
    required String emptyQuote,
  }) {
    if (_loading) return const LoadingState();
    if (_error != null) return ErrorState(message: _error!, onRetry: reload);

    return RefreshIndicator(
      color: AppTheme.accentGreen,
      backgroundColor: AppTheme.surface,
      onRefresh: () => reload(silent: true),
      child: items.isEmpty
          ? ListView(
              children: [
                SizedBox(height: 420, child: _buildEmptyState(quote: emptyQuote)),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(color: Color(0xFF242E37), height: 28),
              itemBuilder: (context, index) {
                final review = items[index];
                return SocialReviewTile(
                  review: review,
                  showAuthor: showAuthor,
                  onAuthorTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(userId: review.userId),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState({required String quote}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF899AA9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
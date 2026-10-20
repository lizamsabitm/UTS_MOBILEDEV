import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../data/fallback_social_data.dart';
import '../data/movie_model.dart';
import '../data/movie_service.dart';
import '../data/review_model.dart';
import 'movie_detail_screen.dart';
import 'widgets/movie_poster_card.dart';
import '../../social/presentation/widgets/review_actions_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  late Future<List<Movie>> _popularMoviesFuture;
  late Future<List<ReviewModel>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    setState(() {
      _popularMoviesFuture = _movieService.fetchPopular();
      _reviewsFuture = _movieService.fetchCommunityReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.headerBackground,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Layarboxd',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
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
              Tab(text: 'Films'),
              Tab(text: 'Reviews'),
              Tab(text: 'Lists'),
              Tab(text: 'Journal'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFilmsTab(),
            _buildReviewsTab(),
            _buildListsTab(),
            _buildJournalTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilmsTab() {
    return RefreshIndicator(
      color: AppTheme.accentGreen,
      backgroundColor: AppTheme.surface,
      onRefresh: () async => _loadMovies(),
      child: FutureBuilder<List<Movie>>(
        future: _popularMoviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonGrid();
          }

          if (snapshot.hasError) {
            return ErrorState(
              message: 'Failed to load popular movies. Please check connection.',
              onRetry: _loadMovies,
            );
          }

          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return EmptyState(
              message: 'No movies available at the moment.',
              actionLabel: 'Try Again',
              onAction: _loadMovies,
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'Popular this week',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 6 : 4;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
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
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      itemCount: 16,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F2730),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return FutureBuilder<List<ReviewModel>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        final liveReviews = snapshot.data ?? [];
        final hasLive = liveReviews.isNotEmpty;
        final count = hasLive ? liveReviews.length : FallbackSocialData.popularReviews.length;

        return RefreshIndicator(
          color: AppTheme.accentGreen,
          backgroundColor: AppTheme.surface,
          onRefresh: () async {
            _loadMovies();
            await _reviewsFuture;
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            itemCount: count + 1,
            separatorBuilder: (_, idx) =>
                idx == 0 ? const SizedBox.shrink() : const Divider(color: Color(0xFF242E37), height: 32),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hasLive ? 'Community Reviews ($count)' : 'Popular this week',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasLive)
                        const Text(
                          'LIVE FROM MYSQL',
                          style: TextStyle(
                            color: AppTheme.accentGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                    ],
                  ),
                );
              }

              final idx = index - 1;
              final movieTitle = hasLive
                  ? (liveReviews[idx].movieTitle ?? 'Film Review')
                  : FallbackSocialData.popularReviews[idx].movieTitle;
              final releaseYear = hasLive
                  ? ''
                  : FallbackSocialData.popularReviews[idx].releaseYear;
              final authorName = hasLive
                  ? liveReviews[idx].name
                  : FallbackSocialData.popularReviews[idx].authorName;
              final authorAvatar = hasLive
                  ? null
                  : FallbackSocialData.popularReviews[idx].authorAvatar;
              final rating = hasLive
                  ? liveReviews[idx].rating
                  : FallbackSocialData.popularReviews[idx].rating;
              final hasHeart = hasLive
                  ? false
                  : FallbackSocialData.popularReviews[idx].hasHeart;
              final content = hasLive
                  ? liveReviews[idx].content
                  : FallbackSocialData.popularReviews[idx].content;
              final posterUrl = hasLive
                  ? liveReviews[idx].posterUrl
                  : FallbackSocialData.popularReviews[idx].posterUrl;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Movie title + year (left), author name + avatar (right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: movieTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (releaseYear.isNotEmpty) ...[
                                TextSpan(
                                  text: ' $releaseYear',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authorName,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: const Color(0xFF2C3946),
                        backgroundImage: authorAvatar != null
                            ? NetworkImage(authorAvatar)
                            : null,
                        child: authorAvatar == null
                            ? Text(
                                authorName.isNotEmpty ? authorName[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Row 2: Star rating
                  Row(
                    children: [
                      ...List.generate(5, (sIdx) {
                        final isFilled = rating >= (sIdx + 1);
                        return Icon(
                          isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 16,
                          color: isFilled
                              ? const Color(0xFF00E054)
                              : const Color(0xFF33414E),
                        );
                      }),
                      if (hasHeart) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.favorite,
                          size: 14,
                          color: Color(0xFFFF8000),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Row 3: Poster (left) + Review text (right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 80,
                          height: 120,
                          child: Image.network(
                            posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: const Color(0xFF2C3946)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          content,
                          style: const TextStyle(
                            color: Color(0xFFBAC6D0),
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasLive) ...[
                    const SizedBox(height: 8),
                    ReviewActionsBar(
                      key: ValueKey('home-review-${liveReviews[idx].id}'),
                      reviewId: liveReviews[idx].id,
                      initialLiked: liveReviews[idx].likedByMe,
                      initialLikeCount: liveReviews[idx].likeCount,
                      initialCommentCount: liveReviews[idx].commentCount,
                    ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildListsTab() {
    const lists = FallbackSocialData.popularLists;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      itemCount: lists.length + 1,
      separatorBuilder: (_, idx) =>
          idx == 0 ? const SizedBox.shrink() : const Divider(color: Color(0xFF242E37), height: 36),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'Popular this week',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        final list = lists[index - 1];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List Header: Title, Curator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    list.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      list.curatorName,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: const Color(0xFF2C3946),
                      backgroundImage: NetworkImage(list.curatorAvatar),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Horizontal row / fan of movie posters
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.posterUrls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (ctx, pIdx) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: SizedBox(
                      width: 64,
                      height: 96,
                      child: Image.network(
                        list.posterUrls[pIdx],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: const Color(0xFF2C3946)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              list.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF899AA9),
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJournalTab() {
    final journalEntries = [
      {
        'image': 'https://image.tmdb.org/t/p/w780/pB8BM7pdSp6B6Ih7QI4S2t0POhQ.jpg',
        'title': 'Dancing Through Life',
        'subtitle': 'Oscar winner Michelle Yeoh on her illustrious, action-packed career.',
      },
      {
        'image': 'https://image.tmdb.org/t/p/w780/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
        'title': 'Behold the Holy Grail',
        'subtitle': 'The scandal, suppression and salvation of Ken Russell\'s The Devils.',
      },
      {
        'image': 'https://image.tmdb.org/t/p/w780/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
        'title': 'The Enduring Wonder of Sci-Fi Cinema',
        'subtitle': 'How visionary directors used practical miniatures and scientific fidelity to capture humanity\'s deepest existential questions.',
      },
      {
        'image': 'https://image.tmdb.org/t/p/w780/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
        'title': 'A Century of Shadow and Light',
        'subtitle': 'Exploring the evolution of cinematography from silent film to modern masterpieces.',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      itemCount: journalEntries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final entry = journalEntries[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: const Color(0xFF1B2228),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                entry['image']!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: const Color(0xFF2C3946),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry['subtitle']!,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }
}

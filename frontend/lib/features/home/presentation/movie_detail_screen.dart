import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/fallback_social_data.dart';
import '../data/movie_model.dart';
import '../data/movie_service.dart';
import '../data/review_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieService _movieService = MovieService();
  late Movie _currentMovie;
  List<ReviewModel> _reviews = [];
  bool _isLoadingDetail = false;
  bool _isWatched = false;
  bool _isLiked = false;
  bool _isInWatchlist = false;
  double _userRating = 0.0;
  int _selectedTab = 0; // 0: Cast, 1: Crew, 2: Details, 3: Genre, 4: Releases

  @override
  void initState() {
    super.initState();
    _currentMovie = widget.movie;
    _fetchDetails();
    _fetchReviews();
    _checkWatchlist();
  }

  Future<void> _checkWatchlist() async {
    final isWatchlisted = await _movieService.checkWatchlist(widget.movie.id);
    if (mounted) {
      setState(() => _isInWatchlist = isWatchlisted);
    }
  }

  Future<void> _fetchDetails() async {
    setState(() => _isLoadingDetail = true);
    final detail = await _movieService.fetchDetail(widget.movie.id);
    if (mounted && detail != null) {
      setState(() {
        _currentMovie = detail;
        _isLoadingDetail = false;
      });
    } else if (mounted) {
      setState(() => _isLoadingDetail = false);
    }
  }

  Future<void> _fetchReviews() async {
    final reviews = await _movieService.fetchReviews(widget.movie.id);
    if (mounted) {
      setState(() {
        _reviews = reviews;
      });
    }
  }

  Future<void> _toggleWatchlist() async {
    final willAdd = !_isInWatchlist;
    setState(() => _isInWatchlist = willAdd);

    bool success;
    if (willAdd) {
      success = await _movieService.addToWatchlist(
        tmdbId: _currentMovie.id,
        title: _currentMovie.title,
        posterPath: _currentMovie.posterPath,
      );
    } else {
      success = await _movieService.removeFromWatchlist(_currentMovie.id);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            willAdd
                ? (success ? 'Added to your Watchlist' : 'Saved to watchlist')
                : (success ? 'Removed from your Watchlist' : 'Removed from watchlist'),
          ),
          backgroundColor: const Color(0xFF1F2730),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _openLogModal([double initialRating = 0.0]) {
    double selectedRating = initialRating > 0 ? initialRating : _userRating;
    bool watchedNow = _isWatched;
    bool likedNow = _isLiked;
    final reviewController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B2228),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF455565),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentMovie.fullPosterUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              width: 50,
                              height: 75,
                              child: Image.network(
                                _currentMovie.fullPosterUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentMovie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_currentMovie.releaseYear.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  _currentMovie.releaseYear,
                                  style: const TextStyle(
                                    color: Color(0xFF899AA9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Quick Action Toggles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildModalToggle(
                          icon: watchedNow ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                          label: 'Watched',
                          isActive: watchedNow,
                          color: const Color(0xFF00E054),
                          onTap: () => setModalState(() => watchedNow = !watchedNow),
                        ),
                        _buildModalToggle(
                          icon: likedNow ? Icons.favorite : Icons.favorite_border,
                          label: 'Like',
                          isActive: likedNow,
                          color: const Color(0xFFFF8000),
                          onTap: () => setModalState(() => likedNow = !likedNow),
                        ),
                        _buildModalToggle(
                          icon: _isInWatchlist ? Icons.access_time_filled : Icons.access_time,
                          label: 'Watchlist',
                          isActive: _isInWatchlist,
                          color: const Color(0xFF40BCE8),
                          onTap: () {
                            setModalState(() => _isInWatchlist = !_isInWatchlist);
                            _toggleWatchlist();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'RATING',
                      style: TextStyle(
                        color: Color(0xFF677785),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Star rating bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starVal = index + 1.0;
                        final isFilled = selectedRating >= starVal;
                        return IconButton(
                          iconSize: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          icon: Icon(
                            isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: isFilled ? const Color(0xFF00E054) : const Color(0xFF455565),
                          ),
                          onPressed: () {
                            setModalState(() {
                              selectedRating = (selectedRating == starVal) ? 0.0 : starVal;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reviewController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Add a review...',
                        hintStyle: const TextStyle(color: Color(0xFF677785)),
                        filled: true,
                        fillColor: const Color(0xFF202830),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E054),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                setModalState(() => isSubmitting = true);
                                await _movieService.addReview(
                                  tmdbId: _currentMovie.id,
                                  title: _currentMovie.title,
                                  posterPath: _currentMovie.posterPath,
                                  rating: selectedRating,
                                  content: reviewController.text.trim(),
                                );
                                if (modalCtx.mounted) Navigator.pop(modalCtx);
                                if (mounted) {
                                  setState(() {
                                    _userRating = selectedRating;
                                    _isWatched = watchedNow;
                                    _isLiked = likedNow;
                                  });
                                  _fetchReviews();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Saved to your log!'),
                                      backgroundColor: Color(0xFF1F2730),
                                    ),
                                  );
                                }
                              },
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalToggle({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: isActive ? color : const Color(0xFF677785), size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : const Color(0xFF677785),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backdropUrl = _currentMovie.fullBackdropUrl;
    final posterUrl = _currentMovie.fullPosterUrl;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Sliver Header
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppTheme.headerBackground,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (backdropUrl != null)
                    CachedNetworkImage(
                      imageUrl: backdropUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(color: AppTheme.surface),
                    )
                  else
                    Container(color: AppTheme.surface),
                  // Dark fade
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.background.withValues(alpha: 0.7),
                          AppTheme.background,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoadingDetail)
            const SliverToBoxAdapter(
              child: LinearProgressIndicator(
                color: AppTheme.accentGreen,
                backgroundColor: AppTheme.surface,
                minHeight: 2,
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Poster Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentMovie.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                if (_currentMovie.releaseYear.isNotEmpty)
                                  Text(
                                    _currentMovie.releaseYear,
                                    style: const TextStyle(
                                      color: Color(0xFF899AA9),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (_currentMovie.director != null)
                                  Text(
                                    'DIRECTED BY ${_currentMovie.director!.toUpperCase()}',
                                    style: const TextStyle(
                                      color: Color(0xFF899AA9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Trailer Button & Runtime
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C3946),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.play_arrow, color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'TRAILER',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _currentMovie.formattedRuntime.isNotEmpty
                                      ? _currentMovie.formattedRuntime
                                      : '124 mins',
                                  style: const TextStyle(
                                    color: Color(0xFF899AA9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      if (posterUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            width: 86,
                            height: 126,
                            child: CachedNetworkImage(
                              imageUrl: posterUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(color: AppTheme.surface),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tagline
                  if (_currentMovie.tagline != null && _currentMovie.tagline!.isNotEmpty) ...[
                    Text(
                      _currentMovie.tagline!.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF899AA9),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Overview / Synopsis
                  if (_currentMovie.overview != null && _currentMovie.overview!.isNotEmpty)
                    Text(
                      _currentMovie.overview!,
                      style: const TextStyle(
                        color: Color(0xFFBAC6D0),
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                  const SizedBox(height: 20),

                  // RATINGS Bar Histogram (Screenshot 192919 style)
                  _buildRatingsHistogram(),
                  const SizedBox(height: 14),

                  // After Login Rate & Log action pill container (Screenshot 192919)
                  _buildAfterLoginRateBar(),
                  const SizedBox(height: 16),

                  // 3 Stat Cards: Members, Reviews, Lists (Screenshot 192919)
                  _buildStatCardsRow(),
                  const SizedBox(height: 24),

                  // Horizontal Category Tabs (Cast, Crew, Details, Genre, Releases)
                  _buildCategoryTabs(),
                  const SizedBox(height: 16),

                  // Cast Avatars
                  if (_selectedTab == 0 && _currentMovie.cast.isNotEmpty) ...[
                    _buildCastList(),
                    const SizedBox(height: 24),
                  ] else if (_selectedTab == 3) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _currentMovie.genres
                          .map((g) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF202830),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  g,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Popular Reviews Section
                  _buildPopularReviewsSection(),
                  const SizedBox(height: 24),

                  // OPEN IN Row
                  _buildOpenInRow(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsHistogram() {
    return Column(
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
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFF00E054), size: 14),
            const SizedBox(width: 8),
            // Simulated Letterboxd rating histogram bars
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildHistBar(4),
                  _buildHistBar(6),
                  _buildHistBar(10),
                  _buildHistBar(18),
                  _buildHistBar(30),
                  _buildHistBar(55),
                  _buildHistBar(85),
                  _buildHistBar(120),
                  _buildHistBar(70),
                  _buildHistBar(90),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      color: Color(0xFF00E054),
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistBar(double height) {
    return Expanded(
      child: Container(
        height: height * 0.25,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: const Color(0xFF455565),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildAfterLoginRateBar() {
    return InkWell(
      onTap: () => _openLogModal(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF202830),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Color(0xFF2C3946),
              child: Icon(Icons.person, size: 14, color: Color(0xFF899AA9)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _userRating > 0
                    ? 'Rated ${_userRating.toStringAsFixed(1)} ★  ·  Tap to edit'
                    : 'Rate, log, review, add to list + more',
                style: TextStyle(
                  color: _userRating > 0 ? const Color(0xFF00E054) : const Color(0xFF899AA9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.more_horiz, color: Color(0xFF899AA9), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardsRow() {
    return Row(
      children: [
        // Green card: Members
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF00E054),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.remove_red_eye, color: Colors.black, size: 20),
                SizedBox(height: 8),
                Text(
                  'Members',
                  style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  '140k',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Slate card: Reviews
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF455565),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.article_outlined, color: Colors.white, size: 20),
                SizedBox(height: 8),
                Text(
                  'Reviews',
                  style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  '78k',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Blue card: Lists
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF40BCE8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.layers_outlined, color: Colors.black, size: 20),
                SizedBox(height: 8),
                Text(
                  'Lists',
                  style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  '34k',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final tabs = ['Cast', 'Crew', 'Details', 'Genre', 'Releases'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (idx) {
          final isSelected = _selectedTab == idx;
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = idx),
              child: Column(
                children: [
                  Text(
                    tabs[idx],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF677785),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 32,
                    height: 2,
                    color: isSelected ? const Color(0xFF00E054) : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCastList() {
    return Column(
      children: _currentMovie.cast.take(4).map((member) {
        final profileUrl = member.fullProfileUrl;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF27323A),
                backgroundImage: profileUrl != null ? NetworkImage(profileUrl) : null,
                child: profileUrl == null
                    ? const Icon(Icons.person, color: Color(0xFF899AA9), size: 18)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      (member.character != null && member.character!.isNotEmpty)
                          ? member.character!
                          : 'Cast Member',
                      style: const TextStyle(
                        color: Color(0xFF899AA9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF455565), size: 16),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPopularReviewsSection() {
    final sampleReviews = FallbackSocialData.popularReviews.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'POPULAR REVIEWS',
          style: TextStyle(
            color: Color(0xFF677785),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        if (_reviews.isNotEmpty)
          ..._reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFF2C3946),
                          child: Text(
                            r.username.isNotEmpty ? r.username[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          r.username,
                          style: const TextStyle(
                            color: Color(0xFFBAC6D0),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 12,
                              color: r.rating >= (i + 1)
                                  ? const Color(0xFF00E054)
                                  : const Color(0xFF455565),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (r.content.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        r.content,
                        style: const TextStyle(
                          color: Color(0xFF899AA9),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ))
        else
          ...sampleReviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(r.authorAvatar),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          r.authorName,
                          style: const TextStyle(
                            color: Color(0xFFBAC6D0),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(
                            5,
                            (i) => const Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFF00E054),
                            ),
                          ),
                        ),
                        if (r.hasHeart) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.favorite, size: 11, color: Color(0xFFFF8000)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      r.content,
                      style: const TextStyle(
                        color: Color(0xFF899AA9),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              )),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'ALL REVIEWS',
              style: TextStyle(
                color: Color(0xFFBAC6D0),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenInRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OPEN IN',
          style: TextStyle(
            color: Color(0xFF677785),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildBadgePill('WEB'),
            const SizedBox(width: 6),
            _buildBadgePill('IMDB'),
            const SizedBox(width: 6),
            _buildBadgePill('TMDB'),
            const SizedBox(width: 6),
            _buildBadgePill('JUSTWATCH'),
            const Spacer(),
            const Icon(Icons.flag_outlined, color: Color(0xFF677785), size: 18),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgePill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF202830),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFBAC6D0),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

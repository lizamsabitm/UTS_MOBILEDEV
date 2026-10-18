import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:async';
import '../../data/fallback_movies.dart';
import '../../data/movie_model.dart';
import '../../data/movie_service.dart';
import '../movie_detail_screen.dart';

class QuickLogSheet extends StatefulWidget {
  const QuickLogSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const QuickLogSheet(),
    );
  }

  @override
  State<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends State<QuickLogSheet> {
  final TextEditingController _searchController = TextEditingController();
  final MovieService _movieService = MovieService();
  Timer? _debounce;
  List<Movie> _filteredMovies = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredMovies = FallbackMovies.popularMovies.take(6).toList();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final pop = await _movieService.fetchPopular();
    if (mounted) {
      setState(() {
        _filteredMovies = pop.take(8).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.trim().isEmpty) {
        _loadInitial();
      } else {
        setState(() => _isSearching = true);
        final results = await _movieService.search(query.trim());
        if (mounted) {
          setState(() {
            _filteredMovies = results;
            _isSearching = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1B2228),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF455565),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search to log or review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C3946),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter film title...',
                  hintStyle: TextStyle(color: Color(0xFF899AA9), fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF899AA9), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'POPULAR FILMS',
                style: TextStyle(
                  color: Color(0xFF677785),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentGreen,
                      strokeWidth: 2,
                    ),
                  )
                : _filteredMovies.isEmpty
                    ? const Center(
                        child: Text(
                          'No matching films found.',
                          style: TextStyle(color: Color(0xFF899AA9)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _filteredMovies.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Color(0xFF242E37), height: 16),
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            width: 36,
                            height: 52,
                            child: movie.fullPosterUrl != null
                                ? Image.network(
                                    movie.fullPosterUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: const Color(0xFF2C3946)),
                                  )
                                : Container(color: const Color(0xFF2C3946)),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          movie.releaseYear.isNotEmpty
                              ? movie.releaseYear
                              : 'Release Year N/A',
                          style: const TextStyle(
                            color: Color(0xFF899AA9),
                            fontSize: 13,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF677785),
                          size: 14,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

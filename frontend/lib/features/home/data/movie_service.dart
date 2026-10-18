import 'dart:convert';
import '../../../core/network/api_client.dart';
import 'fallback_movies.dart';
import 'movie_model.dart';
import 'review_model.dart';

class MovieService {
  final ApiClient _api = ApiClient();

  Future<List<Movie>> fetchPopular() async {
    try {
      final response = await _api.get('/movies/popular', auth: false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data is Map ? (data['data'] ?? data['movies'] ?? data['results'] ?? []) : data;
        final parsed = Movie.listFromJson(list);
        if (parsed.isNotEmpty) return parsed;
      }
    } catch (_) {}

    // Fallback to curated catalog when backend is offline or loading
    return FallbackMovies.popularMovies;
  }

  Future<List<Movie>> search(String query) async {
    try {
      final response = await _api.get('/movies/search', queryParameters: {'q': query}, auth: false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data is Map ? (data['data'] ?? data['movies'] ?? data['results'] ?? []) : data;
        final parsed = Movie.listFromJson(list);
        if (parsed.isNotEmpty) return parsed;
      }
    } catch (_) {}

    // Fallback search across curated catalog
    final q = query.toLowerCase();
    return FallbackMovies.popularMovies
        .where((m) => m.title.toLowerCase().contains(q) || (m.director?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  Future<Movie?> fetchDetail(int tmdbId) async {
    try {
      final response = await _api.get('/movies/$tmdbId', auth: false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final movieData = data is Map && data.containsKey('data') ? data['data'] : data;
        if (movieData is Map<String, dynamic>) {
          return Movie.fromJson(movieData);
        }
      }
    } catch (_) {}

    // Fallback to local detailed movie data
    try {
      return FallbackMovies.popularMovies.firstWhere((m) => m.id == tmdbId);
    } catch (_) {
      return null;
    }
  }

  Future<List<ReviewModel>> fetchReviews(int tmdbId) async {
    try {
      final response = await _api.get('/reviews/movie/$tmdbId', auth: false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data is Map ? (data['data'] ?? []) : data;
        return ReviewModel.listFromJson(list);
      }
    } catch (_) {}
    return [];
  }

  Future<bool> addReview({
    required int tmdbId,
    required String title,
    String? posterPath,
    required double rating,
    required String content,
  }) async {
    try {
      final response = await _api.post(
        '/reviews',
        body: {
          'tmdbId': tmdbId,
          'title': title,
          'posterPath': posterPath ?? '',
          'rating': rating,
          'content': content,
        },
        auth: true,
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addToWatchlist({
    required int tmdbId,
    required String title,
    String? posterPath,
  }) async {
    try {
      final response = await _api.post(
        '/watchlist',
        body: {
          'tmdbId': tmdbId,
          'title': title,
          'posterPath': posterPath ?? '',
        },
        auth: true,
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFromWatchlist(int tmdbId) async {
    try {
      final response = await _api.delete('/watchlist/$tmdbId', auth: true);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkWatchlist(int tmdbId) async {
    try {
      final response = await _api.get('/watchlist/check/$tmdbId', auth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isWatchlisted'] == true;
      }
    } catch (_) {}
    return false;
  }

  Future<List<ReviewModel>> fetchCommunityReviews() async {
    try {
      final response = await _api.get('/reviews', auth: false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data is Map ? (data['data'] ?? []) : data;
        return ReviewModel.listFromJson(list);
      }
    } catch (_) {}
    return [];
  }

  Future<List<Movie>> fetchWatchlist() async {
    try {
      final response = await _api.get('/watchlist', auth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data is Map ? (data['data'] ?? []) : data;
        if (list is List) {
          return list.map((item) {
            if (item is Map && item.containsKey('movie') && item['movie'] is Map) {
              return Movie.fromJson(item['movie'] as Map<String, dynamic>);
            }
            return Movie.fromJson(item as Map<String, dynamic>);
          }).toList();
        }
      }
    } catch (_) {}
    return [];
  }
}

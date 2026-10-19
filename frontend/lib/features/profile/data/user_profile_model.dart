// features/profile/data/user_profile_model.dart
import '../../home/data/movie_model.dart';

class UserReviewEntry {
  final int id;
  final double rating;
  final String content;
  final String createdAt;
  final Movie? movie;

  UserReviewEntry({
    required this.id,
    required this.rating,
    required this.content,
    required this.createdAt,
    this.movie,
  });

  factory UserReviewEntry.fromJson(Map<String, dynamic> json) {
    Movie? parsedMovie;
    if (json['movie'] != null && json['movie'] is Map) {
      parsedMovie = Movie.fromJson(json['movie'] as Map<String, dynamic>);
    }

    return UserReviewEntry(
      id: json['id'] ?? 0,
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      movie: parsedMovie,
    );
  }
}

class UserProfile {
  final int id;
  final String email;
  final String username;
  final String name;
  final List<UserReviewEntry> reviews;
  final List<Movie> watchlist;
  final int followerCount;
  final int followingCount;
  final int likeCount;

  UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    this.reviews = const [],
    this.watchlist = const [],
    this.followerCount = 0,
    this.followingCount = 0,
    this.likeCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    List<UserReviewEntry> reviewsList = [];
    if (json['reviews'] != null && json['reviews'] is List) {
      reviewsList = (json['reviews'] as List)
          .map((r) => UserReviewEntry.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    List<Movie> watchlistList = [];
    if (json['watchlist'] != null && json['watchlist'] is List) {
      watchlistList = (json['watchlist'] as List).map((w) {
        if (w is Map && w['movie'] != null && w['movie'] is Map) {
          return Movie.fromJson(w['movie'] as Map<String, dynamic>);
        }
        return Movie.fromJson(w as Map<String, dynamic>);
      }).toList();
    }
    final counts = json['_count'] is Map ? json['_count'] as Map : const {};
    return UserProfile(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      reviews: reviewsList,
      watchlist: watchlistList,
      followerCount: counts['followers'] ?? 0,
      followingCount: counts['following'] ?? 0,
      likeCount: counts['likes'] ?? 0,
    );
  }
}

// features/home/data/review_model.dart

class ReviewModel {
  final int id;
  final double rating;
  final String content;
  final String createdAt;
  final String username;
  final String name;
  final String? movieTitle;
  final String? posterPath;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.username,
    required this.name,
    this.movieTitle,
    this.posterPath,
  });

  String get posterUrl {
    if (posterPath != null && posterPath!.isNotEmpty) {
      if (posterPath!.startsWith('http')) return posterPath!;
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://image.tmdb.org/t/p/w500/bjiS5ipwxb9JFy3XRRN4OAilSeX.jpg';
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    String username = 'Member';
    String name = 'Anonymous';
    String? movieTitle;
    String? posterPath;

    if (json['user'] != null && json['user'] is Map) {
      username = json['user']['username'] ?? username;
      name = json['user']['name'] ?? name;
    }

    if (json['movie'] != null && json['movie'] is Map) {
      movieTitle = json['movie']['title'];
      posterPath = json['movie']['posterPath'];
    }

    return ReviewModel(
      id: json['id'] ?? 0,
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      username: username,
      name: name,
      movieTitle: movieTitle,
      posterPath: posterPath,
    );
  }

  static List<ReviewModel> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}

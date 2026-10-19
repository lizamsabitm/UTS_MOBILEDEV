// features/home/data/review_model.dart

class ReviewModel {
  final int id;
  final int userId;
  final double rating;
  final String content;
  final String createdAt;
  final String username;
  final String name;
  final String? movieTitle;
  final String? posterPath;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;

  ReviewModel({
    required this.id,
    this.userId = 0,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.username,
    required this.name,
    this.movieTitle,
    this.posterPath,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByMe = false,
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
    int userId = json['userId'] ?? 0;
    String? movieTitle;
    String? posterPath;

    if (json['user'] != null && json['user'] is Map) {
      username = json['user']['username'] ?? username;
      name = json['user']['name'] ?? name;
      userId = json['user']['id'] ?? userId;
    }

    if (json['movie'] != null && json['movie'] is Map) {
      movieTitle = json['movie']['title'];
      posterPath = json['movie']['posterPath'];
    }

    return ReviewModel(
      id: json['id'] ?? 0,
      userId: userId,
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      username: username,
      name: name,
      movieTitle: movieTitle,
      posterPath: posterPath,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      likedByMe: json['likedByMe'] == true,
    );
  }

  static List<ReviewModel> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
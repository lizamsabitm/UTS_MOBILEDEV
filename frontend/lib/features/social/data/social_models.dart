import '../../home/data/review_model.dart';

class SocialUser {
  final int id;
  final String username;
  final String name;
  bool isFollowing;

  SocialUser({
    required this.id,
    required this.username,
    required this.name,
    this.isFollowing = false,
  });

  String get displayName => name.isNotEmpty ? name : username;

  factory SocialUser.fromJson(Map<String, dynamic> json) {
    return SocialUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      isFollowing: json['isFollowing'] == true,
    );
  }

  static List<SocialUser> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => SocialUser.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}

class ReviewComment {
  final int id;
  final int userId;
  final String username;
  final String name;
  final String content;
  final String createdAt;

  ReviewComment({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    required this.content,
    required this.createdAt,
  });

  String get displayName => name.isNotEmpty ? name : username;

  factory ReviewComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map ? json['user'] as Map : const {};
    return ReviewComment(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? user['id'] ?? 0,
      username: user['username'] ?? '',
      name: user['name'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  static List<ReviewComment> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => ReviewComment.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}

class PublicProfile {
  final int id;
  final String username;
  final String name;
  final int followerCount;
  final int followingCount;
  final int reviewCount;
  final bool isFollowing;
  final List<ReviewModel> reviews;

  PublicProfile({
    required this.id,
    required this.username,
    required this.name,
    required this.followerCount,
    required this.followingCount,
    required this.reviewCount,
    required this.isFollowing,
    required this.reviews,
  });

  String get displayName => name.isNotEmpty ? name : username;

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      isFollowing: json['isFollowing'] == true,
      reviews: ReviewModel.listFromJson(json['reviews']),
    );
  }
}
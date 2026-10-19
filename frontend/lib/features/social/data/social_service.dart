import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../../home/data/review_model.dart';
import 'social_models.dart';

/// Ubah exception menjadi pesan yang layak ditampilkan di SnackBar / ErrorState.
String friendlyError(Object error) {
  if (error is TimeoutException) return 'Koneksi ke server timeout. Coba lagi.';
  final text = error.toString();
  if (text.contains('SocketException') || text.contains('ClientException')) {
    return 'Tidak dapat terhubung ke server.';
  }
  return text.replaceFirst('Exception: ', '');
}

class SocialService {
  final ApiClient _api = ApiClient();

  dynamic _decode(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = null;
    }
    if (response.statusCode >= 200 && response.statusCode < 300) return body;
    final message = (body is Map && body['error'] != null)
        ? body['error'].toString()
        : 'Terjadi kesalahan (${response.statusCode})';
    throw Exception(message);
  }

  // ---------- Follow ----------
  Future<List<SocialUser>> searchUsers(String query) async {
    final res = await _api.get('/users/search', queryParameters: {'q': query}, auth: true);
    return SocialUser.listFromJson(_decode(res)['data']);
  }

  Future<PublicProfile> fetchPublicProfile(int userId) async {
    final res = await _api.get('/users/$userId', auth: true);
    return PublicProfile.fromJson(_decode(res)['data'] as Map<String, dynamic>);
  }

  Future<int> follow(int userId) async {
    final res = await _api.post('/users/$userId/follow', auth: true);
    return (_decode(res)['followerCount'] as num?)?.toInt() ?? 0;
  }

  Future<int> unfollow(int userId) async {
    final res = await _api.delete('/users/$userId/follow', auth: true);
    return (_decode(res)['followerCount'] as num?)?.toInt() ?? 0;
  }

  Future<List<SocialUser>> fetchFollowers(int userId) async {
    final res = await _api.get('/users/$userId/followers', auth: true);
    return SocialUser.listFromJson(_decode(res)['data']);
  }

  Future<List<SocialUser>> fetchFollowing(int userId) async {
    final res = await _api.get('/users/$userId/following', auth: true);
    return SocialUser.listFromJson(_decode(res)['data']);
  }

  // ---------- Feed ----------
  Future<List<ReviewModel>> fetchFeed() async {
    final res = await _api.get('/reviews/feed', auth: true);
    return ReviewModel.listFromJson(_decode(res)['data']);
  }

  Future<List<ReviewModel>> fetchMyReviews() async {
    final res = await _api.get('/reviews/my', auth: true);
    return ReviewModel.listFromJson(_decode(res)['data']);
  }

  // ---------- Like ----------
  Future<int> likeReview(int reviewId) async {
    final res = await _api.post('/reviews/$reviewId/like', auth: true);
    return (_decode(res)['likeCount'] as num?)?.toInt() ?? 0;
  }

  Future<int> unlikeReview(int reviewId) async {
    final res = await _api.delete('/reviews/$reviewId/like', auth: true);
    return (_decode(res)['likeCount'] as num?)?.toInt() ?? 0;
  }

  // ---------- Komentar ----------
  Future<List<ReviewComment>> fetchComments(int reviewId) async {
    final res = await _api.get('/reviews/$reviewId/comments', auth: false);
    return ReviewComment.listFromJson(_decode(res)['data']);
  }

  Future<ReviewComment> addComment(int reviewId, String content) async {
    final res = await _api.post(
      '/reviews/$reviewId/comments',
      body: {'content': content},
      auth: true,
    );
    return ReviewComment.fromJson(_decode(res)['data'] as Map<String, dynamic>);
  }

  Future<void> deleteComment(int reviewId, int commentId) async {
    final res = await _api.delete('/reviews/$reviewId/comments/$commentId', auth: true);
    _decode(res);
  }
}
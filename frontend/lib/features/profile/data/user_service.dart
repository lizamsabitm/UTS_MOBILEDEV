// features/profile/data/user_service.dart
import 'dart:convert';
import '../../../core/network/api_client.dart';
import 'user_profile_model.dart';

class UserService {
  final ApiClient _api = ApiClient();

  Future<UserProfile?> fetchProfile() async {
    try {
      final response = await _api.get('/users/profile', auth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data is Map && data.containsKey('data') ? data['data'] : data;
        if (userData is Map<String, dynamic>) {
          return UserProfile.fromJson(userData);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<bool> updateProfile({String? name, String? username}) async {
    try {
      final response = await _api.put(
        '/users/profile',
        body: {
          if (name != null) 'name': name,
          if (username != null) 'username': username,
        },
        auth: true,
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

// features/auth/data/auth_service.dart
import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  Future<bool> login({required String email, required String password}) async {
    final response = await _api.post('/auth/login',
        body: {'email': email, 'password': password}, auth: false);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] ?? data['jwt'] ?? data['accessToken'];
      if (token != null && token is String) {
        await TokenStorage.saveToken(token);
        final username = data['username'] ?? data['user']?['username'] ?? '';
        final name = data['user']?['name'] ?? '';
        final email = data['user']?['email'] ?? '';
        await TokenStorage.saveUserInfo(username: username, name: name, email: email);
        return true;
      }
    }
    return false;
  }

  Future<bool> register({required String email, required String username, required String password, required String name}) async {
    final response = await _api.post('/auth/register',
        body: {
          'email': email,
          'username': username,
          'password': password,
          'name': name,
        },
        auth: false);
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
  }
}

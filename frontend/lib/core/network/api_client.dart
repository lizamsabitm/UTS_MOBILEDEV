// core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ApiClient {
  final http.Client _client = http.Client();
  static const Duration timeoutDuration = Duration(seconds: 3);

  Future<http.Response> get(String path, {Map<String, String>? queryParameters, bool auth = false}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: queryParameters);
    final headers = await _buildHeaders(auth: auth);
    return _client.get(uri, headers: headers).timeout(timeoutDuration);
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body, bool auth = false}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = await _buildHeaders(auth: auth, isJson: true);
    return _client.post(uri, headers: headers, body: jsonEncode(body ?? {})).timeout(timeoutDuration);
  }

  Future<http.Response> put(String path, {Map<String, dynamic>? body, bool auth = false}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = await _buildHeaders(auth: auth, isJson: true);
    return _client.put(uri, headers: headers, body: jsonEncode(body ?? {})).timeout(timeoutDuration);
  }

  Future<http.Response> delete(String path, {bool auth = false}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = await _buildHeaders(auth: auth);
    return _client.delete(uri, headers: headers).timeout(timeoutDuration);
  }

  Future<Map<String, String>> _buildHeaders({bool auth = false, bool isJson = false}) async {
    final headers = <String, String>{};
    if (isJson) headers['Content-Type'] = 'application/json';
    if (auth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  void close() => _client.close();
}

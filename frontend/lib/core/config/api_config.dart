// core/config/api_config.dart
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String _envUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static String? _cachedBaseUrl;

  // The local IP of the developer PC on Wi-Fi (for testing on real physical Android devices)
  static const String defaultLanUrl = 'http://192.168.1.5:3000/api';
  // Android emulator loopback alias
  static const String emulatorUrl = 'http://10.0.2.2:3000/api';

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedBaseUrl = prefs.getString('api_base_url');
    } catch (_) {}
  }

  static String get baseUrl {
    if (_cachedBaseUrl != null && _cachedBaseUrl!.isNotEmpty) {
      return _cachedBaseUrl!;
    }
    if (_envUrl.isNotEmpty) return _envUrl;
    if (kIsWeb) return 'http://localhost:3000/api';
    try {
      if (Platform.isAndroid) {
        // Physical devices on the same Wi-Fi connect to developer's LAN IP
        return defaultLanUrl;
      }
    } catch (_) {}
    return 'http://localhost:3000/api';
  }

  static Future<void> setBaseUrl(String url) async {
    _cachedBaseUrl = url.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_base_url', _cachedBaseUrl!);
    } catch (_) {}
  }
}

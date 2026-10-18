// core/config/api_config.dart
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ApiConfig {
  static const String _envUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get baseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    if (kIsWeb) return 'http://localhost:3000/api';
    try {
      if (Platform.isAndroid) {
        // 10.0.2.2 is the special alias to the host loopback interface on Android emulators
        return 'http://10.0.2.2:3000/api';
      }
    } catch (_) {}
    return 'http://localhost:3000/api';
  }
}

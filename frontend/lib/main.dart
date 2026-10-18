import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.init();
  runApp(const LayarboxdApp());
}

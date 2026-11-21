import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Restore user's saved theme preference before the widget tree builds
  await appThemeController.loadFromPrefs();

  runApp(const ImposterApp());
}

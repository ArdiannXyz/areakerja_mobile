import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => getLightTheme();
  static ThemeData get dark => getDarkTheme();
}

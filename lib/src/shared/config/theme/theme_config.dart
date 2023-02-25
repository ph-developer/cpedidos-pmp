import 'package:flutter/material.dart';
part 'color_schemes.g.dart';
part 'widget_decorations.g.dart';

abstract class ThemeConfig {
  static ThemeMode themeMode = ThemeMode.light;

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        inputDecorationTheme: _inputDecorationTheme,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _darkColorScheme,
        inputDecorationTheme: _inputDecorationTheme,
      );

  static ThemeData get systemTheme =>
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          ? darkTheme
          : lightTheme;

  static ThemeData get currentTheme {
    if (themeMode == ThemeMode.system) {
      return systemTheme;
    } else if (themeMode == ThemeMode.dark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }
}

import 'package:flutter/material.dart';

part 'color_schemes.g.dart';
part 'widget_decorations.g.dart';

ThemeData get _lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      inputDecorationTheme: _inputDecorationTheme,
    );

ThemeData get _darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      inputDecorationTheme: _inputDecorationTheme,
    );

ThemeData get _systemTheme =>
    WidgetsBinding.instance.window.platformBrightness == Brightness.dark
        ? _darkTheme
        : _lightTheme;

ThemeMode themeMode = ThemeMode.light;

ThemeData get currentTheme {
  if (themeMode == ThemeMode.system) {
    return _systemTheme;
  } else if (themeMode == ThemeMode.dark) {
    return _darkTheme;
  } else {
    return _lightTheme;
  }
}

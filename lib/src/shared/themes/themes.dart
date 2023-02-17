import 'package:flutter/material.dart';

part 'color_schemes.g.dart';

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      inputDecorationTheme: _inputDecorationTheme,
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      inputDecorationTheme: _inputDecorationTheme,
    );

InputDecorationTheme get _inputDecorationTheme => const InputDecorationTheme(
      border: OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isDense: true,
    );

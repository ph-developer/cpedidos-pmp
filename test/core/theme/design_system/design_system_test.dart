import 'package:cpedidos_pmp/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  group('currentTheme', () {
    test(
      'should return a ThemeData when themeMode is system and system is light.',
      () async {
        // arrange
        themeMode = ThemeMode.system;
        binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;
        // act
        final result = currentTheme;
        // assert
        expect(result, isA<ThemeData>());
      },
    );

    test(
      'should return a ThemeData when themeMode is system and system is dark.',
      () async {
        // arrange
        themeMode = ThemeMode.system;
        binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.dark;
        // act
        final result = currentTheme;
        // assert
        expect(result, isA<ThemeData>());
      },
    );

    test(
      'should return a ThemeData when themeMode is light.',
      () async {
        // arrange
        themeMode = ThemeMode.light;
        // act
        final result = currentTheme;
        // assert
        expect(result, isA<ThemeData>());
      },
    );

    test(
      'should return a ThemeData when themeMode is dark.',
      () async {
        // arrange
        themeMode = ThemeMode.dark;
        // act
        final result = currentTheme;
        // assert
        expect(result, isA<ThemeData>());
      },
    );
  });
}

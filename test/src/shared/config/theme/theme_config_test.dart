import 'package:cpedidos_pmp/src/shared/config/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final widgetsBinding = TestWidgetsFlutterBinding.ensureInitialized();

  group('systemTheme', () {
    test(
      'should return the darkTheme when platformBrightness is dark.',
      () async {
        // arrange
        widgetsBinding.window.platformDispatcher.platformBrightnessTestValue =
            Brightness.dark;
        // act
        final result = ThemeConfig.systemTheme;
        // assert
        expect(result, equals(ThemeConfig.darkTheme));
      },
    );

    test(
      'should return the lightTheme when platformBrightness is light.',
      () async {
        // arrange
        widgetsBinding.window.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;
        // act
        final result = ThemeConfig.systemTheme;
        // assert
        expect(result, equals(ThemeConfig.lightTheme));
      },
    );
  });

  group('currentTheme', () {
    test(
      'should return the systemTheme when themeMode is system.',
      () async {
        // arrange
        ThemeConfig.themeMode = ThemeMode.system;
        // act
        final result = ThemeConfig.currentTheme;
        // assert
        expect(result, equals(ThemeConfig.systemTheme));
      },
    );

    test(
      'should return the lightTheme when themeMode is light.',
      () async {
        // arrange
        ThemeConfig.themeMode = ThemeMode.light;
        // act
        final result = ThemeConfig.currentTheme;
        // assert
        expect(result, equals(ThemeConfig.lightTheme));
      },
    );

    test(
      'should return the darkTheme when themeMode is dark.',
      () async {
        // arrange
        ThemeConfig.themeMode = ThemeMode.dark;
        // act
        final result = ThemeConfig.currentTheme;
        // assert
        expect(result, equals(ThemeConfig.darkTheme));
      },
    );
  });
}

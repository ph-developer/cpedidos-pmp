import 'dart:math';

enum FindMode { startsWith, contains, endsWith }

extension StringHelper on String {
  static String generateRandom(int length) {
    final rng = Random();
    const chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        r'!@#$%^&*()';
    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      final randomNumber = rng.nextInt(chars.length);
      buffer.write(chars[randomNumber]);
    }

    return buffer.toString();
  }

  bool has(String query, [FindMode mode = FindMode.contains]) {
    var regExp =
        RegExp.escape(query).replaceAll('%', '.*').replaceAll('_', '.');

    switch (mode) {
      case FindMode.startsWith:
        regExp = '^$regExp';
        break;
      case FindMode.endsWith:
        regExp = '$regExp\$';
        break;
      case FindMode.contains:
        break;
    }

    return RegExp(regExp).hasMatch(this);
  }
}

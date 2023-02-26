import 'dart:math';

String generateRandomString(int length) {
  final rng = Random();
  const chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
      r'!@#$%^&*()';
  final buffer = StringBuffer();

  for (var i = 0; i < length; i++) {
    final randomNumber = rng.nextInt(chars.length);
    buffer.write(chars[randomNumber]);
  }

  return buffer.toString();
}

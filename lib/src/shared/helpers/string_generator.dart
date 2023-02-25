import 'dart:math';

String generateRandomString(int length) {
  final rng = Random();
  const chars =
      '0123456789abcdefghijklmnopqrstuvwxyz!@#\$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var string = '';

  for (var i = 0; i < length; i++) {
    final randomNumber = rng.nextInt(chars.length);

    string += chars[randomNumber];
  }

  return string;
}

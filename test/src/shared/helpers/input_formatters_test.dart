import 'package:cpedidos_pmp/src/shared/helpers/input_formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingValue textEditingValue;

  setUp(() {
    textEditingValue = TextEditingValue.empty;
  });

  group('digitsOnly', () {
    test(
      'should accept only numbers.',
      () async {
        // arrange
        const tChars =
            ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.digitsOnly;
        // act
        for (final char in tChars.split('')) {
          textEditingValue = formatter.formatEditUpdate(
            textEditingValue,
            TextEditingValue(text: textEditingValue.text + char),
          );
        }
        final result = textEditingValue.text;
        // assert
        expect(result, equals('0123456789'));
      },
    );
  });

  group('digitsAndOneHyphenOnly', () {
    test(
      'should accept only numbers and hyphens.',
      () async {
        // arrange
        const tChars =
            ' -abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234-56789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.digitsAndOneHyphenOnly;
        // act
        for (final char in tChars.split('')) {
          textEditingValue = formatter.formatEditUpdate(
            textEditingValue,
            TextEditingValue(text: textEditingValue.text + char),
          );
        }
        final result = textEditingValue.text;
        // assert
        expect(result, equals('01234-56789'));
      },
    );
  });

  group('digitsAndOneDotOnly', () {
    test(
      'should accept only numbers and one dot.',
      () async {
        // arrange
        const tChars =
            ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.01.23.45.67.89.\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.digitsAndOneDotOnly;
        // act
        for (final char in tChars.split('')) {
          textEditingValue = formatter.formatEditUpdate(
            textEditingValue,
            TextEditingValue(text: textEditingValue.text + char),
          );
        }
        final result = textEditingValue.text;
        // assert
        expect(result, equals('01.23456789'));
      },
    );
  });

  group('uppercase', () {
    test(
      'should uppercase inputted characters and not affect other chars.',
      () async {
        // arrange
        const tChars =
            ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        const tExpected =
            ' ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.uppercase;
        // act
        for (final char in tChars.split('')) {
          textEditingValue = formatter.formatEditUpdate(
            textEditingValue,
            TextEditingValue(text: textEditingValue.text + char),
          );
        }
        final result = textEditingValue.text;
        // assert
        expect(result, equals(tExpected));
      },
    );
  });

  group('date', () {
    test(
      'should accept only numbers and format as date.',
      () async {
        // arrange
        const tChars =
            ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.date;
        // act
        for (final char in tChars.split('')) {
          textEditingValue = formatter.formatEditUpdate(
            textEditingValue,
            TextEditingValue(text: textEditingValue.text + char),
          );
        }
        final result = textEditingValue.text;
        // assert
        expect(result, equals('01/23/4567'));
      },
    );
  });
}

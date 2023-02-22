import 'package:flutter_test/flutter_test.dart';

import 'package:cpedidos_pmp/src/shared/helpers/input_formatters.dart';

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
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.digitsOnly;
        // act
        for (var char in tChars.split('')) {
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

  group('digitsAndHyphensOnly', () {
    test(
      'should accept only numbers and hyphens.',
      () async {
        // arrange
        const tChars =
            '-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234-56789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.digitsAndHyphensOnly;
        // act
        for (var char in tChars.split('')) {
          textEditingValue = formatter.formatEditUpdate(
            textEditingValue,
            TextEditingValue(text: textEditingValue.text + char),
          );
        }
        final result = textEditingValue.text;
        // assert
        expect(result, equals('-01234-56789-'));
      },
    );
  });

  group('uppercase', () {
    test(
      'should uppercase inputted characters and not affect other chars.',
      () async {
        // arrange
        const tChars =
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        const tExpected =
            'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.uppercase;
        // act
        for (var char in tChars.split('')) {
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
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\'\\|",<.>;:/?~^[{()}]\$!@#*-_=+%¨&';
        final formatter = InputFormatters.date;
        // act
        for (var char in tChars.split('')) {
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

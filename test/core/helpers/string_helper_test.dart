import 'package:cpedidos_pmp/core/helpers/string_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generateRandom', () {
    test(
      'should generate a string with 15 characters length.',
      () async {
        // arrange
        const tLength = 15;
        // act
        final result = StringHelper.generateRandom(tLength);
        // assert
        expect(result, isA<String>());
        expect(result.length, tLength);
      },
    );
  });

  group('has', () {
    group('mode == FindMode.contains', () {
      test(
        'should return true when contains query.',
        () async {
          // arrange
          const tString = 'testing some things';
          const tQuery = 'es_in%so%m%i_g';
          // act
          final result = tString.has(tQuery);
          // assert
          expect(result, isTrue);
        },
      );

      test(
        'should return false when not contains query.',
        () async {
          // arrange
          const tString = 'testing some things';
          const tQuery = 'es_ig%so%m%i_g';
          // act
          final result = tString.has(tQuery);
          // assert
          expect(result, isFalse);
        },
      );
    });

    group('mode == FindMode.startsWith', () {
      test(
        'should return true when starts with query.',
        () async {
          // arrange
          const tString = 'testing some things';
          const tQuery = 'tes_in%so%m%i_g';
          // act
          final result = tString.has(tQuery, FindMode.startsWith);
          // assert
          expect(result, isTrue);
        },
      );

      test(
        'should return false when not starts with query.',
        () async {
          // arrange
          const tString = 'testing some things';
          const tQuery = 'es_ig%so%m%i_g';
          // act
          final result = tString.has(tQuery, FindMode.startsWith);
          // assert
          expect(result, isFalse);
        },
      );
    });

    group('mode == FindMode.endsWith', () {
      test(
        'should return true when ends with query.',
        () async {
          // arrange
          const tString = 'testing some things';
          const tQuery = 'es_in%so%m%i_gs';
          // act
          final result = tString.has(tQuery, FindMode.endsWith);
          // assert
          expect(result, isTrue);
        },
      );

      test(
        'should return false when not ends with query.',
        () async {
          // arrange
          const tString = 'testing some things';
          const tQuery = 'es_ig%so%m%i_g';
          // act
          final result = tString.has(tQuery, FindMode.endsWith);
          // assert
          expect(result, isFalse);
        },
      );
    });
  });
}

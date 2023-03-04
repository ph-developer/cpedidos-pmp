import 'package:cpedidos_pmp/src/shared/helpers/string_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should generate a string with 15 characters length.',
    () async {
      // arrange
      const tLength = 15;
      // act
      final result = generateRandomString(tLength);
      // assert
      expect(result, isA<String>());
      expect(result.length, tLength);
    },
  );
}

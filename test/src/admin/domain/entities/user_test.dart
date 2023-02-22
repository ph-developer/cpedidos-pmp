import 'package:flutter_test/flutter_test.dart';

import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';

void main() {
  test(
    'should return true when all user props are equals.',
    () async {
      // arrange
      const tUserA = User(id: 'id', email: 'email', name: 'name');
      const tUserB = User(id: 'id', email: 'email', name: 'name');
      // act
      final result = tUserA == tUserB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any user prop are different.',
    () async {
      // arrange
      const tUserA = User(id: 'id', email: 'email', name: 'name1');
      const tUserB = User(id: 'id', email: 'email', name: 'name2');
      // act
      final result = tUserA == tUserB;
      // assert
      expect(result, isFalse);
    },
  );
}

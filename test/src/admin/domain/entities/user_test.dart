import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return true when all user props are equals.',
    () async {
      // arrange
      const tUserA = User(
        id: 'id',
        email: 'email',
        name: 'name',
        isAdmin: true,
      );
      const tUserB = User(
        id: 'id',
        email: 'email',
        name: 'name',
        isAdmin: true,
      );
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
      const tUserA = User(
        id: 'id',
        email: 'email',
        name: 'name',
        isAdmin: true,
      );
      const tUserB = User(
        id: 'id',
        email: 'email',
        name: 'name',
        isAdmin: false,
      );
      // act
      final result = tUserA == tUserB;
      // assert
      expect(result, isFalse);
    },
  );
}

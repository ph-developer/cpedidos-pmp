import 'package:cpedidos_pmp/src/auth/data/dtos/user_dto.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUser = User(
    id: 'id',
    email: 'email',
    name: 'name',
  );
  const tUserMap = {
    'id': 'id',
    'email': 'email',
    'name': 'name',
  };

  group('fromMap', () {
    test(
      'should conver a map to an user entity.',
      () async {
        // act
        final result = UserDTO.fromMap(tUserMap);
        // assert
        expect(result, isA<User>());
        expect(result, equals(tUser));
      },
    );
  });
}

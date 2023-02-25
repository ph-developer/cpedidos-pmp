import 'package:cpedidos_pmp/src/admin/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/admin/infra/dtos/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserMap = {
    'id': 'id',
    'email': 'email',
    'name': 'name',
    'isAdmin': true,
  };
  const tUser = User(id: 'id', email: 'email', name: 'name', isAdmin: true);

  group('fromMap', () {
    test(
      'should return an user.',
      () async {
        // act
        final result = UserDTO.fromMap(tUserMap);
        // assert
        expect(result, equals(tUser));
      },
    );
  });
}

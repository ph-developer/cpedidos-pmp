import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/infra/models/logged_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUser = LoggedUserModel(id: 'id', email: 'email');
  const tUserMap = {'id': 'id', 'email': 'email'};

  test(
    'should extends LoggedUser.',
    () async {
      // assert
      expect(tUser, isA<LoggedUser>());
    },
  );

  group('fromMap', () {
    test(
      'should convert a map to an LoggedUserModel.',
      () async {
        // act
        final result = LoggedUserModel.fromMap(tUserMap);
        // assert
        expect(result, isA<LoggedUserModel>());
        expect(result, equals(tUser));
      },
    );
  });
}

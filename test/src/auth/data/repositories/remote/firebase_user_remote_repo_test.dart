import 'package:cpedidos_pmp/src/auth/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/data/repositories/remote/firebase_user_remote_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late FirebaseDatabase mockDatabase;
  late DatabaseReference mockDatabaseReference;
  late DataSnapshot mockDataSnapshot;
  late FirebaseUserRemoteRepo repo;

  setUp(() {
    mockDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();
    repo = FirebaseUserRemoteRepo(mockDatabase);
  });

  group('getById', () {
    const tUser = User(id: 'id', email: 'email', name: 'name');
    const tUserMap = {'id': 'id', 'email': 'email', 'name': 'name'};

    test(
      'should return an user entity when exists one with id param.',
      () async {
        // arrange
        when(() => mockDatabase.ref('users/id'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(true);
        when(() => mockDataSnapshot.value).thenReturn(tUserMap);
        // act
        final result = await repo.getById('id');
        // assert
        expect(result, isA<User>());
        expect(result, equals(tUser));
      },
    );

    test(
      'should throws an GetUserFailure when not exists one user with id param.',
      () async {
        // arrange
        when(() => mockDatabase.ref('users/not_exists'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(false);
        // act
        final future = repo.getById('not_exists');
        // assert
        expect(future, throwsA(isA<GetUserFailure>()));
      },
    );

    test(
      'should throws a GetUserFailure when an error occurs.',
      () async {
        // arrange
        when(() => mockDatabase.ref('users/throws_error'))
            .thenThrow(Exception());

        // act
        final future = repo.getById('throws_error');
        // assert
        expect(future, throwsA(isA<GetUserFailure>()));
      },
    );
  });
}

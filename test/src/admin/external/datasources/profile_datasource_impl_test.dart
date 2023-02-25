import 'package:cpedidos_pmp/src/admin/external/datasources/profile_datasource_impl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

void main() {
  late DatabaseReference mockDatabaseReference;
  late FirebaseDatabase mockFirebaseDatabase;
  late ProfileDatasourceImpl datasource;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    mockFirebaseDatabase = MockFirebaseDatabase();
    datasource = ProfileDatasourceImpl(mockFirebaseDatabase);
  });

  const tId = 'id';
  const tName = 'name';
  const tIsAdmin = true;
  const tProfileMap = {
    'id': tId,
    'name': tName,
    'isAdmin': tIsAdmin,
  };

  group('createProfile', () {
    test(
      'should return a map when create with success.',
      () async {
        // arrange
        when(() => mockFirebaseDatabase.ref('users/$tId'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.set(tProfileMap))
            .thenAnswer((_) async {});
        // act
        final result = await datasource.createProfile(tId, tName, tIsAdmin);
        // assert
        expect(result, equals(tProfileMap));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseDatabase.ref(any())).thenThrow(tException);
        // act
        final future = datasource.createProfile(tId, tName, tIsAdmin);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });
}

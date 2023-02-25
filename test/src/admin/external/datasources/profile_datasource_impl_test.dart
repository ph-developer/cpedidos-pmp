import 'package:cpedidos_pmp/src/admin/external/datasources/profile_datasource_impl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late DataSnapshot mockDataSnapshot;
  late DatabaseReference mockDatabaseReference;
  late FirebaseDatabase mockFirebaseDatabase;
  late ProfileDatasourceImpl datasource;

  setUp(() {
    mockDataSnapshot = MockDataSnapshot();
    mockDatabaseReference = MockDatabaseReference();
    mockFirebaseDatabase = MockFirebaseDatabase();
    datasource = ProfileDatasourceImpl(mockFirebaseDatabase);
  });

  const tId = 'id';
  const tEmail = 'email';
  const tName = 'name';
  const tIsAdmin = true;
  const tProfileMap = {
    'id': tId,
    'email': tEmail,
    'name': tName,
    'isAdmin': tIsAdmin,
  };
  const tProfilesMap = {tId: tProfileMap};
  const tProfilesList = [tProfileMap];

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
        final result =
            await datasource.createProfile(tId, tEmail, tName, tIsAdmin);
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
        final future = datasource.createProfile(tId, tEmail, tName, tIsAdmin);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('deleteProfile', () {
    test(
      'should return true when delete with success.',
      () async {
        // arrange
        when(() => mockFirebaseDatabase.ref('users/$tId'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.remove()).thenAnswer((_) async {});
        // act
        final result = await datasource.deleteProfile(tId);
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseDatabase.ref(any())).thenThrow(tException);
        // act
        final future = datasource.deleteProfile(tId);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('getAllProfiles', () {
    test(
      'should return a list of profile maps when get with success.',
      () async {
        // arrange
        when(() => mockFirebaseDatabase.ref('users'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.value).thenReturn(tProfilesMap);
        // act
        final result = await datasource.getAllProfiles();
        // assert
        expect(result, equals(tProfilesList));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseDatabase.ref(any())).thenThrow(tException);
        // act
        final future = datasource.getAllProfiles();
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });
}

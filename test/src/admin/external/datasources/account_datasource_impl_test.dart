import 'package:cpedidos_pmp/src/admin/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/admin/external/datasources/account_datasource_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late User mockUser;
  late UserCredential mockUserCredential;
  late FirebaseAuth mockFirebaseAuth;
  late AccountDatasourceImpl datasource;

  setUp(() {
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockFirebaseAuth = MockFirebaseAuth();
    datasource = AccountDatasourceImpl(mockFirebaseAuth);
  });

  const tId = 'id';
  const tEmail = 'test@test.dev';
  const tPassword = 'password';

  group('createAccount', () {
    test(
      'should return an user id when create with success.',
      () async {
        // arrange
        when(() => mockUser.uid).thenReturn(tId);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenAnswer((_) async => mockUserCredential);
        // act
        final result = await datasource.createAccount(tEmail, tPassword);
        // assert
        expect(result, equals(tId));
      },
    );

    test(
      'should throws an emailAlreadyInUse failure when firebase throws an email-already-in-use exception.',
      () async {
        // arrange
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
        // act
        final future = datasource.createAccount(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(AdminFailure.emailAlreadyInUse)));
      },
    );

    test(
      'should throws an invalidEmail failure when firebase throws an invalid-email exception.',
      () async {
        // arrange
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(FirebaseAuthException(code: 'invalid-email'));
        // act
        final future = datasource.createAccount(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(AdminFailure.invalidEmail)));
      },
    );

    test(
      'should throws an operationNotAllowed failure when firebase throws an operation-not-allowed exception.',
      () async {
        // arrange
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));
        // act
        final future = datasource.createAccount(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(AdminFailure.operationNotAllowed)));
      },
    );

    test(
      'should throws an weakPassword failure when firebase throws an weak-password exception.',
      () async {
        // arrange
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(FirebaseAuthException(code: 'weak-password'));
        // act
        final future = datasource.createAccount(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(AdminFailure.weakPassword)));
      },
    );

    test(
      'should rethrows an exception when firebase throws an unknown exception.',
      () async {
        // arrange
        final tException = FirebaseAuthException(code: '');
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(tException);
        // act
        final future = datasource.createAccount(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(tException);
        // act
        final future = datasource.createAccount(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('createAccount', () {
    test(
      'should return true when delete with success.',
      () async {
        // act
        final result = await datasource.deleteAccount(tId);
        // assert
        expect(result, isTrue);
      },
    );
  });
}

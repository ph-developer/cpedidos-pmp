import 'package:cpedidos_pmp/features/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/auth/external/datasources/auth_datasource_impl.dart';
import 'package:cpedidos_pmp/features/auth/infra/models/logged_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late User mockUser;
  late UserCredential mockUserCredential;
  late UserCredential mockNullCredential;
  late FirebaseAuth mockFirebaseAuth;
  late AuthDatasourceImpl datasource;

  setUp(() {
    mockUser = MockFirebaseUser();
    mockUserCredential = MockUserCredential();
    mockNullCredential = MockUserCredential();
    mockFirebaseAuth = MockFirebaseAuth();
    datasource = AuthDatasourceImpl(mockFirebaseAuth);

    registerFallbackValue(MockAuthCredential());

    when(() => mockUser.uid).thenReturn('id');
    when(() => mockUser.email).thenReturn('test@test.dev');
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockNullCredential.user).thenReturn(null);
  });

  const tId = 'id';
  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  const tLoggedUserModel = LoggedUserModel(id: tId, email: tEmail);

  group('login', () {
    test(
      'should return a LoggedUserModel on successfull login.',
      () async {
        // arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        // act
        final result = await datasource.login(tEmail, tPassword);
        // assert
        expect(result, equals(tLoggedUserModel));
      },
    );

    test(
      'should throws an UserDisabled failure when user has been disabled.',
      () async {
        // arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-disabled'));
        // act
        final future = datasource.login(tEmail, tPassword);
        // assert
        expect(future, throwsA(isA<UserDisabled>()));
      },
    );

    test(
      'should throws an InvalidCredentials failure when user email is invalid.',
      () async {
        // arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));
        // act
        final future = datasource.login(tEmail, tPassword);
        // assert
        expect(future, throwsA(isA<InvalidCredentials>()));
      },
    );

    test(
      'should throws an InvalidCredentials failure when user has not found.',
      () async {
        // arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));
        // act
        final future = datasource.login(tEmail, tPassword);
        // assert
        expect(future, throwsA(isA<InvalidCredentials>()));
      },
    );

    test(
      'should return a InvalidCredentials failure when password is incorrect.',
      () async {
        // arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));
        // act
        final future = datasource.login(tEmail, tPassword);
        // assert
        expect(future, throwsA(isA<InvalidCredentials>()));
      },
    );

    test(
      'should rethrows an exception when firebase throws an unknown exception.',
      () async {
        // arrange
        final tException = FirebaseAuthException(code: '');
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(tException);
        // act
        final future = datasource.login(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(tException);
        // act
        final future = datasource.login(tEmail, tPassword);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('logout', () {
    test(
      'should return true on successfull logout.',
      () async {
        // arrange
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        // act
        final result = await datasource.logout();
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseAuth.signOut()).thenThrow(tException);
        // act
        final future = datasource.logout();
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('getCurrentUser', () {
    test(
      'should return a LoggedUserModel when user is logged in.',
      () async {
        // arrange
        when(() => mockFirebaseAuth.currentUser).thenAnswer((_) => null);
        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([mockUser]));
        // act
        final result = await datasource.getCurrentUser();
        // assert
        expect(result, equals(tLoggedUserModel));
      },
    );

    test(
      "should throws an UserUnauthenticated failure when user isn't logged in.",
      () async {
        // arrange
        when(() => mockFirebaseAuth.currentUser).thenAnswer((_) => null);
        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([null]));
        // act
        final future = datasource.getCurrentUser();
        // assert
        expect(future, throwsA(isA<UserUnauthenticated>()));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseAuth.currentUser).thenThrow(tException);
        // act
        final future = datasource.getCurrentUser();
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });
}

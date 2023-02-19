import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/auth/data/repositories/remote/firebase_auth_remote_repo.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';

class MockFirebaseUser extends Mock implements firebase.User {}

class MockUserCredential extends Mock implements firebase.UserCredential {}

class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}

class MockAuthCredential extends Mock implements firebase.AuthCredential {}

void main() {
  late firebase.User userMock;
  late firebase.UserCredential userCredentialMock;
  late firebase.UserCredential nullCredentialMock;
  late firebase.FirebaseAuth authMock;
  late FirebaseAuthRemoteRepo repo;

  setUp(() {
    userMock = MockFirebaseUser();
    userCredentialMock = MockUserCredential();
    nullCredentialMock = MockUserCredential();
    authMock = MockFirebaseAuth();
    repo = FirebaseAuthRemoteRepo(authMock);

    registerFallbackValue(MockAuthCredential());

    when(() => userMock.uid).thenReturn('test');
    when(() => userMock.email).thenReturn('test@test.dev');
    when(() => userCredentialMock.user).thenReturn(userMock);
    when(() => nullCredentialMock.user).thenReturn(null);
  });

  group('login', () {
    test(
      'should return an user id when successfull login.',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => userCredentialMock);
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result.getOrNull(), isA<String>());
      },
    );

    test(
      'should return an UserDisabled failure when user has been disabled.',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(firebase.FirebaseAuthException(code: 'user-disabled'));
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result.exceptionOrNull(), isA<UserDisabled>());
      },
    );

    test(
      'should return a InvalidCredentials failure when user email is invalid.',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(firebase.FirebaseAuthException(code: 'invalid-email'));
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result.exceptionOrNull(), isA<InvalidCredentials>());
      },
    );

    test(
      'should return a InvalidCredentials failure when user has not found.',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ))
            .thenThrow(firebase.FirebaseAuthException(code: 'user-not-found'));
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result.exceptionOrNull(), isA<InvalidCredentials>());
      },
    );

    test(
      'should return a InvalidCredentials failure when password is incorrect.',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ))
            .thenThrow(firebase.FirebaseAuthException(code: 'wrong-password'));
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result.exceptionOrNull(), isA<InvalidCredentials>());
      },
    );

    test(
      'should rethrow an FirebaseAuthException when throws undefined firebase error code.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(firebase.FirebaseAuthException(code: 'undefined'));
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<firebase.FirebaseAuthException>()));
      },
    );

    test(
      'should return a InvalidCredentials failure when firebase returns null credentials',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => nullCredentialMock);
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result.exceptionOrNull(), isA<InvalidCredentials>());
      },
    );
  });

  group('logout', () {
    test(
      'should return true on successfull logout.',
      () async {
        // arrange
        when(() => authMock.signOut()).thenAnswer((_) async {});
        // act
        final result = await repo.logout();
        // assert
        expect(result.getOrNull(), isTrue);
      },
    );
  });

  group('getCurrentUserId', () {
    test(
      'should return the current user id when user is logged in.',
      () async {
        // arrange
        when(() => authMock.currentUser).thenAnswer((_) => null);
        when(authMock.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([userMock]));
        // act
        final result = await repo.getCurrentUserId();
        // assert
        expect(result.getOrNull(), isA<String>());
      },
    );

    test(
      'should return an UserUnauthenticated failure when user is not logged in.',
      () async {
        // arrange
        when(() => authMock.currentUser).thenAnswer((_) => null);
        when(authMock.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([null]));
        // act
        final result = await repo.getCurrentUserId();
        // assert
        expect(result.exceptionOrNull(), isA<UserUnauthenticated>());
      },
    );
  });
}

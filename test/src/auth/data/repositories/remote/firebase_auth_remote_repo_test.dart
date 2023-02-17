import 'package:cpedidos_pmp/src/auth/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/data/repositories/remote/firebase_auth_remote_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
      'should return user id when successfull login.',
      () async {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => userCredentialMock);
        // act
        final result = await repo.login('test@test.dev', 'test');
        // assert
        expect(result, isA<String>());
      },
    );

    test(
      'should throws a LoginFailure when usar has been blocked.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(firebase.FirebaseAuthException(code: 'user-disabled'));
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
      },
    );

    test(
      'should throws a LoginFailure when user email is invalid.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(firebase.FirebaseAuthException(code: 'invalid-email'));
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
      },
    );

    test(
      'should throws a LoginFailure when user has not found.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ))
            .thenThrow(firebase.FirebaseAuthException(code: 'user-not-found'));
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
      },
    );

    test(
      'should throws a LoginFailure when password is incorrect.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ))
            .thenThrow(firebase.FirebaseAuthException(code: 'wrong-password'));
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
      },
    );

    test(
      'should throws a LoginFailure when throws undefined firebase error code.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(firebase.FirebaseAuthException(code: 'undefined'));
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
      },
    );

    test(
      'should throws a LoginFailure when firebase returns null credentials',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => nullCredentialMock);
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
      },
    );

    test(
      'should throws a LoginFailure when an error occurs.',
      () {
        // arrange
        when(() => authMock.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception());
        // act
        final result = repo.login('test@test.dev', 'test');
        // assert
        expect(result, throwsA(isA<LoginFailure>()));
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
        expect(result, isA<bool>());
        expect(result, true);
      },
    );

    test(
      'should throws a LogoutFailure when an error occurs.',
      () {
        // arrange
        when(() => authMock.signOut()).thenThrow(Exception());
        // act
        final result = repo.logout();
        // assert
        expect(result, throwsA(isA<LogoutFailure>()));
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
        expect(result, isA<String>());
      },
    );

    test(
      'should return null when user is not logged in.',
      () async {
        // arrange
        when(() => authMock.currentUser).thenAnswer((_) => null);
        when(authMock.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([null]));
        // act
        final result = await repo.getCurrentUserId();
        // assert
        expect(result, isNull);
      },
    );
  });

  group('currentUserIdChanged', () {
    test(
      'should send user id over stream on successfull login.',
      () {
        // arrange
        when(authMock.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([userMock]));
        // act
        final stream = repo.currentUserIdChanged();
        // assert
        expect(stream, emits(isA<String>()));
      },
    );

    test(
      'should send null over stream on successfull logout.',
      () {
        // arrange
        when(authMock.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([null]));
        // act
        final stream = repo.currentUserIdChanged();
        // assert
        expect(stream, emits(null));
      },
    );
  });
}

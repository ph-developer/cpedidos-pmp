import 'package:cpedidos_pmp/features/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/features/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/features/auth/presentation/stores/auth_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../helpers.dart';
import '../../../../mocks.dart';

void main() {
  late IDoLogin mockDoLogin;
  late IDoLogout mockDoLogout;
  late IGetCurrentUser mockGetCurrentUser;
  late AuthStore store;

  setUp(() {
    mockDoLogin = MockDoLogin();
    mockDoLogout = MockDoLogout();
    mockGetCurrentUser = MockGetCurrentUser();
    store = AuthStore(mockGetCurrentUser, mockDoLogin, mockDoLogout)
      ..toString();
  });

  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  const tLoggedUser = LoggedUser(id: 'id', email: tEmail);
  final tFailure = MockAuthFailure();

  group('fetchLoggedUser', () {
    test(
      'should emits in order when user is logged in.',
      () async {
        // arrange
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => const Success(tLoggedUser));
        final tester = MobxTester()
          ..addReaction('isLoading', () => store.isLoading)
          ..addReaction('loggedUser', () => store.loggedUser);
        // act
        await store.fetchLoggedUser();
        // assert
        tester
          ..addVerification('isLoading', true)
          ..addVerification('loggedUser', tLoggedUser)
          ..addVerification('isLoading', false)
          ..verifyInOrder();
      },
    );

    test(
      'should emits in order when user is not logged in.',
      () async {
        // arrange
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => const Failure(UserUnauthenticated()));
        final tester = MobxTester()
          ..addReaction('isLoading', () => store.isLoading)
          ..addReaction('loggedUser', () => store.loggedUser);
        // act
        store.loggedUser = tLoggedUser;
        await store.fetchLoggedUser();
        // assert
        tester
          ..addVerification('isLoading', true)
          ..addVerification('loggedUser', null)
          ..addVerification('isLoading', false)
          ..verifyInOrder();
      },
    );
  });

  group('doLogin', () {
    test(
      'should emits in order when log in with success.',
      () async {
        // arrange
        when(() => mockDoLogin(tEmail, tPassword))
            .thenAnswer((_) async => const Success(tLoggedUser));
        final tester = MobxTester()
          ..addReaction('isLoading', () => store.isLoading)
          ..addReaction('loggedUser', () => store.loggedUser);
        // act
        await store.doLogin({'email': tEmail, 'password': tPassword});
        // assert
        tester
          ..addVerification('isLoading', true)
          ..addVerification('loggedUser', tLoggedUser)
          ..addVerification('isLoading', false)
          ..verifyInOrder();
      },
    );

    test(
      'should emits in order when login fails.',
      () async {
        // arrange
        when(() => mockDoLogin(tEmail, tPassword))
            .thenAnswer((_) async => Failure(tFailure));
        final tester = MobxTester()
          ..addReaction('isLoading', () => store.isLoading)
          ..addReaction('failure', () => store.failure);
        // act
        await store.doLogin({'email': tEmail, 'password': tPassword});
        // assert
        tester
          ..addVerification('isLoading', true)
          ..addVerification('failure', tFailure)
          ..addVerification('isLoading', false)
          ..verifyInOrder();
      },
    );
  });

  group('doLogout', () {
    test(
      'should emits in order when log out with success.',
      () async {
        // arrange
        when(() => mockDoLogout()).thenAnswer((_) async => const Success(unit));
        final tester = MobxTester()
          ..addReaction('isLoading', () => store.isLoading)
          ..addReaction('loggedUser', () => store.loggedUser);
        // act
        store.loggedUser = tLoggedUser;
        await store.doLogout();
        // assert
        tester
          ..addVerification('isLoading', true)
          ..addVerification('loggedUser', null)
          ..addVerification('isLoading', false)
          ..verifyInOrder();
      },
    );

    test(
      'should emits in order when logout fails.',
      () async {
        // arrange
        when(() => mockDoLogout()).thenAnswer((_) async => Failure(tFailure));
        final tester = MobxTester()
          ..addReaction('isLoading', () => store.isLoading)
          ..addReaction('failure', () => store.failure);
        // act
        await store.doLogout();
        // assert
        tester
          ..addVerification('isLoading', true)
          ..addVerification('failure', tFailure)
          ..addVerification('isLoading', false)
          ..verifyInOrder();
      },
    );
  });
}

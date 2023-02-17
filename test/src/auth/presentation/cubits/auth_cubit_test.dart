import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:cpedidos_pmp/src/shared/errors/failure.dart';

class MockGetCurrentUser extends Mock implements IGetCurrentUser {}

class MockDoLogin extends Mock implements IDoLogin {}

class MockDoLogout extends Mock implements IDoLogout {}

class MockFailure extends Failure {
  MockFailure([String message = 'failure']) : super(message);
}

void main() {
  late IGetCurrentUser mockGetCurrentUser;
  late IDoLogin mockDoLogin;
  late IDoLogout mockDoLogout;

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUser();
    mockDoLogin = MockDoLogin();
    mockDoLogout = MockDoLogout();
  });

  const tUser = User(id: 'id', email: 'email', name: 'name');
  final tFailure = MockFailure();

  blocTest<AuthCubit, AuthState>(
    'should emits [AuthInitialState] when instance is created.',
    build: () => AuthCubit(
      mockGetCurrentUser,
      mockDoLogin,
      mockDoLogout,
    ),
    verify: (cubit) {
      expect(cubit.state, equals(AuthInitialState()));
    },
  );

  group('fetchLoggedUser', () {
    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoadingState, AuthLoggedInState] when user is logged in.',
      setUp: () {
        when(() => mockGetCurrentUser()).thenAnswer((_) async => tUser);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      ),
      act: (cubit) => cubit.fetchLoggedUser(),
      expect: () => [
        AuthLoadingState(),
        AuthLoggedInState(loggedUser: tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoadingState, AuthLoggedOutState] when user is not logged in.',
      setUp: () {
        when(() => mockGetCurrentUser()).thenAnswer((_) async => null);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      ),
      act: (cubit) => cubit.fetchLoggedUser(),
      expect: () => [
        AuthLoadingState(),
        AuthLoggedOutState(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoadingState, AuthFailureState, AuthLoggedOutState] when usecase throws a failure.',
      setUp: () {
        when(() => mockGetCurrentUser()).thenThrow(tFailure);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      ),
      act: (cubit) => cubit.fetchLoggedUser(),
      expect: () => [
        AuthLoadingState(),
        AuthFailureState(failure: tFailure),
        AuthLoggedOutState(),
      ],
    );
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'should emits nothing when user is not logged out.',
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedInState(loggedUser: tUser)),
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoggingInState, AuthLoggedInState] when user log in successfull.',
      setUp: () {
        when(() => mockDoLogin(any(), any())).thenAnswer((_) async => tUser);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedOutState()),
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [
        AuthLoggingInState(),
        AuthLoggedInState(loggedUser: tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoggingInState, AuthLoggedOutState] when login fails.',
      setUp: () {
        when(() => mockDoLogin(any(), any())).thenAnswer((_) async => null);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedOutState()),
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [
        AuthLoggingInState(),
        AuthLoggedOutState(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoggingInState, AuthFailureState] when usecase throws a failure.',
      setUp: () {
        when(() => mockDoLogin(any(), any())).thenThrow(tFailure);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedOutState()),
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [
        AuthLoggingInState(),
        AuthFailureState(failure: tFailure),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'should emits nothing when user is not logged in.',
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedOutState()),
      act: (cubit) => cubit.logout(),
      expect: () => [],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoggingOutState, AuthLoggedOutState] when user log out successfull.',
      setUp: () {
        when(() => mockDoLogout()).thenAnswer((_) async => true);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedInState(loggedUser: tUser)),
      act: (cubit) => cubit.logout(),
      expect: () => [
        AuthLoggingOutState(),
        AuthLoggedOutState(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoggingOutState, AuthLoggedInState] when logout fails.',
      setUp: () {
        when(() => mockDoLogout()).thenAnswer((_) async => false);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedInState(loggedUser: tUser)),
      act: (cubit) => cubit.logout(),
      expect: () => [
        AuthLoggingOutState(),
        AuthLoggedInState(loggedUser: tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emits [AuthLoggingOutState, AuthFailureState] when usecase throws a failure.',
      setUp: () {
        when(() => mockDoLogout()).thenThrow(tFailure);
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedInState(loggedUser: tUser)),
      act: (cubit) => cubit.logout(),
      expect: () => [
        AuthLoggingOutState(),
        AuthFailureState(failure: tFailure),
      ],
    );
  });
}

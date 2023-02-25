import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/src/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockGetCurrentUser extends Mock implements IGetCurrentUser {}

class MockDoLogin extends Mock implements IDoLogin {}

class MockDoLogout extends Mock implements IDoLogout {}

class MockAuthFailure extends Mock implements AuthFailure {}

void main() {
  late IGetCurrentUser mockGetCurrentUser;
  late IDoLogin mockDoLogin;
  late IDoLogout mockDoLogout;

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUser();
    mockDoLogin = MockDoLogin();
    mockDoLogout = MockDoLogout();
  });

  const tUser = LoggedUser(id: 'id', email: 'email');
  final tAuthFailure = MockAuthFailure();

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
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => const Success(tUser));
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
      'should emits [AuthLoadingState, AuthFailureState, AuthLoggedOutState] when user is not logged in.',
      setUp: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Failure(tAuthFailure));
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      ),
      act: (cubit) => cubit.fetchLoggedUser(),
      expect: () => [
        AuthLoadingState(),
        AuthFailureState(failure: tAuthFailure),
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
        when(() => mockDoLogin(any(), any()))
            .thenAnswer((_) async => const Success(tUser));
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
      'should emits [AuthLoggingInState, AuthFailureState, AuthLoggedOutState] when login fails.',
      setUp: () {
        when(() => mockDoLogin(any(), any()))
            .thenAnswer((_) async => Failure(tAuthFailure));
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedOutState()),
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [
        AuthLoggingInState(),
        AuthFailureState(failure: tAuthFailure),
        AuthLoggedOutState(),
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
        when(() => mockDoLogout()).thenAnswer((_) async => const Success(unit));
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
      'should emits [AuthLoggingOutState,AuthFailureState, AuthLoggedInState] when logout fails.',
      setUp: () {
        when(() => mockDoLogout())
            .thenAnswer((_) async => Failure(tAuthFailure));
      },
      build: () => AuthCubit(
        mockGetCurrentUser,
        mockDoLogin,
        mockDoLogout,
      )..emit(AuthLoggedInState(loggedUser: tUser)),
      act: (cubit) => cubit.logout(),
      expect: () => [
        AuthLoggingOutState(),
        AuthFailureState(failure: tAuthFailure),
        AuthLoggedInState(loggedUser: tUser),
      ],
    );
  });
}

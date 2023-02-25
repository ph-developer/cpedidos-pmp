import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:cpedidos_pmp/src/auth/presentation/guards/auth_guard.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

class MockModularRoute extends Mock implements ModularRoute {}

class MockModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.instance<AuthCubit>(MockAuthCubit()),
      ];
}

void main() {
  final AuthCubit mockAuthCubit = MockAuthCubit();
  late AuthGuard guard;

  initModule(MockModule(), replaceBinds: [
    Bind.instance<AuthCubit>(mockAuthCubit),
  ]);

  setUp(() {
    guard = AuthGuard();
  });

  const tUser = LoggedUser(id: 'id', email: 'email');
  final tModularRoute = MockModularRoute();

  group('canActivate', () {
    test(
      'should return true when auth cubit state is AuthLoggedInState.',
      () async {
        // arrange
        when(() => mockAuthCubit.state)
            .thenReturn(AuthLoggedInState(loggedUser: tUser));
        // act
        final result = await guard.canActivate('', tModularRoute);
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should return false when auth cubit state is AuthLoggedOutState.',
      () async {
        // arrange
        when(() => mockAuthCubit.state).thenReturn(AuthLoggedOutState());
        // act
        final result = await guard.canActivate('', tModularRoute);
        // assert
        expect(result, isFalse);
      },
    );

    test(
      'should wait for next state when cubit state is AuthLoadingState.',
      () async {
        // arrange
        whenListen(
          mockAuthCubit,
          Stream.fromIterable([AuthLoggedInState(loggedUser: tUser)]),
          initialState: AuthLoadingState(),
        );
        // act
        final result = await guard.canActivate('', tModularRoute);
        // assert
        expect(result, isTrue);
      },
    );
  });
}

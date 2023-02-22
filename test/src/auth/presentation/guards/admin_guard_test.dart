import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

import 'package:cpedidos_pmp/src/auth/domain/entities/user.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:cpedidos_pmp/src/auth/presentation/guards/admin_guard.dart';

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
  late AdminGuard guard;

  initModule(MockModule(), replaceBinds: [
    Bind.instance<AuthCubit>(mockAuthCubit),
  ]);

  setUp(() {
    guard = AdminGuard();
  });

  const tUser = User(id: 'id', email: 'email', name: 'name');
  const tAdminUser = User(
    id: 'id',
    email: 'email',
    name: 'name',
    isAdmin: true,
  );
  final tModularRoute = MockModularRoute();

  group('canActivate', () {
    test(
      'should return true when auth cubit state is AuthLoggedInState and user is admin.',
      () async {
        // arrange
        when(() => mockAuthCubit.state)
            .thenReturn(AuthLoggedInState(loggedUser: tAdminUser));
        // act
        final result = await guard.canActivate('', tModularRoute);
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should return false when auth cubit state is AuthLoggedInState and user is not admin.',
      () async {
        // arrange
        when(() => mockAuthCubit.state)
            .thenReturn(AuthLoggedInState(loggedUser: tUser));
        // act
        final result = await guard.canActivate('', tModularRoute);
        // assert
        expect(result, isFalse);
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
          Stream.fromIterable([AuthLoggedInState(loggedUser: tAdminUser)]),
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

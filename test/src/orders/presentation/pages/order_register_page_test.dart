import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart'
    hide InitialState;
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_state.dart';
import 'package:cpedidos_pmp/src/orders/presentation/pages/order_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

import '../../mocks.dart';

class TestModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.instance<OrderRegisterCubit>(MockOrderRegisterCubit()),
        Bind.instance<AuthCubit>(MockAuthCubit()),
      ];
}

void main() {
  final OrderRegisterCubit mockOrderRegisterCubit = MockOrderRegisterCubit();
  final AuthCubit mockAuthCubit = MockAuthCubit();

  initModule(
    TestModule(),
    replaceBinds: [
      Bind.instance<OrderRegisterCubit>(mockOrderRegisterCubit),
      Bind.instance<AuthCubit>(mockAuthCubit),
    ],
  );

  const tLoggedUser = LoggedUser(id: 'id', email: 'test@test.dev');

  testWidgets('should test order register page', (tester) async {
    // late Finder widget;

    whenListen(
      mockAuthCubit,
      Stream<AuthState>.fromIterable([]),
      initialState: LoggedInState(loggedUser: tLoggedUser),
    );

    whenListen(
      mockOrderRegisterCubit,
      Stream<OrderRegisterState>.fromIterable([]),
      initialState: InitialState(),
    );

    when(mockOrderRegisterCubit.reset).thenAnswer((_) async => {});

    const testablePage = MaterialApp(home: OrderRegisterPage());

    await tester.pumpWidget(testablePage);
  });
}

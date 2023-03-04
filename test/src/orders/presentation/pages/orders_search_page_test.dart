import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart'
    hide InitialState;
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_state.dart';
import 'package:cpedidos_pmp/src/orders/presentation/pages/orders_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

import '../../../helpers.dart';
import '../../mocks.dart';

class TestModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.instance<OrdersSearchCubit>(MockOrdersSearchCubit()),
        Bind.instance<AuthCubit>(MockAuthCubit()),
      ];
}

void main() {
  final OrdersSearchCubit mockOrdersSearchCubit = MockOrdersSearchCubit();
  final AuthCubit mockAuthCubit = MockAuthCubit();

  initModule(
    TestModule(),
    replaceBinds: [
      Bind.instance<OrdersSearchCubit>(mockOrdersSearchCubit),
      Bind.instance<AuthCubit>(mockAuthCubit),
    ],
  );

  const tLoggedUser = LoggedUser(id: 'id', email: 'test@test.dev');

  testWidgets('should test orders search page', (tester) async {
    disableOverflowErrors();

    // late Finder widget;

    whenListen(
      mockAuthCubit,
      Stream<AuthState>.fromIterable([]),
      initialState: LoggedInState(loggedUser: tLoggedUser),
    );

    whenListen(
      mockOrdersSearchCubit,
      Stream<OrdersSearchState>.fromIterable([]),
      initialState: InitialState(),
    );

    when(mockOrdersSearchCubit.reset).thenAnswer((_) async => {});

    const testablePage = MaterialApp(home: OrdersSearchPage());

    await tester.pumpWidget(testablePage);
  });
}

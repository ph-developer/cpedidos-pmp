import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_state.dart';
import 'package:cpedidos_pmp/src/auth/presentation/pages/login_page.dart';
import 'package:cpedidos_pmp/src/shared/widgets/buttons/outline_button.dart';
import 'package:cpedidos_pmp/src/shared/widgets/inputs/password_input.dart';
import 'package:cpedidos_pmp/src/shared/widgets/inputs/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

import '../../mocks.dart';

class TestModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.instance<AuthCubit>(MockAuthCubit()),
      ];
}

void main() {
  final AuthCubit mockAuthCubit = MockAuthCubit();

  initModule(
    TestModule(),
    replaceBinds: [
      Bind.instance<AuthCubit>(mockAuthCubit),
    ],
  );

  testWidgets('should test login page', (tester) async {
    late Finder widget;

    whenListen(
      mockAuthCubit,
      Stream.fromIterable([LoggedOutState()]),
      initialState: LoggedOutState(),
    );

    when(() => mockAuthCubit.login(any(), any())).thenAnswer((_) async => {});

    const testablePage = MaterialApp(home: LoginPage());

    await tester.pumpWidget(testablePage);

    widget = find.bySubtype<LoginPage>();
    expect(widget, findsOneWidget);

    widget = find.bySubtype<TextInput>();
    expect(widget, findsOneWidget);

    widget = find.bySubtype<PasswordInput>();
    expect(widget, findsOneWidget);

    widget = find.bySubtype<OutlineButton>();
    expect(widget, findsOneWidget);

    widget = find.bySubtype<TextInput>();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    verifyNever(() => mockAuthCubit.login('', ''));

    widget = find.bySubtype<PasswordInput>();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    verifyNever(() => mockAuthCubit.login('', ''));

    widget = find.bySubtype<OutlineButton>();
    await tester.tap(widget);
    await tester.pumpAndSettle();
    verify(() => mockAuthCubit.login('', '')).called(1);

    widget = find.bySubtype<TextInput>();
    await tester.enterText(widget, 'test@test.dev');
    widget = find.bySubtype<PasswordInput>();
    await tester.enterText(widget, 'password');

    widget = find.bySubtype<OutlineButton>();
    await tester.tap(widget);
    await tester.pumpAndSettle();
    verify(() => mockAuthCubit.login('test@test.dev', 'password')).called(1);
  });
}

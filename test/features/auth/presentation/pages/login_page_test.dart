import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:cpedidos_pmp/core/router/router.dart';
import 'package:cpedidos_pmp/core/theme/theme.dart';
import 'package:cpedidos_pmp/features/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/features/auth/presentation/pages/login_page.dart';
import 'package:cpedidos_pmp/features/auth/presentation/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IDoLogin mockDoLogin;
  late IDoLogout mockDoLogout;
  late IGetCurrentUser mockGetCurrentUser;
  late SnackbarHelper mockSnackbarHelper;
  late AuthStore authStore;

  setUp(() {
    mockDoLogin = MockDoLogin();
    mockDoLogout = MockDoLogout();
    mockGetCurrentUser = MockGetCurrentUser();
    mockSnackbarHelper = MockSnackbarHelper();
    authStore = AuthStore(mockGetCurrentUser, mockDoLogin, mockDoLogout);

    registerFallbackValue(MockBuildContext());

    setupInjector((injector) async {
      injector
        ..removeAll()
        ..addInstance<AuthStore>(authStore)
        ..commit();
    });
  });

  router = MockGoRouter();

  const tEmail = 'test@test.dev';
  const tPassword = 'password';
  final tFailure = MockAuthFailure();
  const tLoggedUser = LoggedUser(id: 'id', email: tEmail);

  testWidgets(
    'should test login page',
    (tester) async {
      SnackbarHelper.delegate = mockSnackbarHelper;

      when(() => router.go(any())).thenAnswer((_) {});
      when(() => tFailure.message).thenReturn('fails');
      when(() => mockDoLogin('', ''))
          .thenAnswer((_) async => Failure(tFailure));
      when(() => mockDoLogin(tEmail, tPassword))
          .thenAnswer((_) async => const Success(tLoggedUser));

      late Finder widget;

      const testablePage = MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        ),
      );

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
      await tester.enterText(widget, '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      verify(() => mockDoLogin('', '')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.bySubtype<PasswordInput>();
      await tester.enterText(widget, '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      verify(() => mockDoLogin('', '')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.bySubtype<OutlineButton>();
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockDoLogin('', '')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.bySubtype<TextInput>();
      await tester.enterText(widget, tEmail);
      await tester.pump();
      widget = find.bySubtype<PasswordInput>();
      await tester.enterText(widget, tPassword);
      await tester.pump();

      widget = find.byIcon(Icons.lock_outline_rounded);
      await tester.tap(widget);
      await tester.pump();

      widget = find.bySubtype<OutlineButton>();
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockDoLogin(tEmail, tPassword)).called(1);
      verify(() => router.go('/pedidos/cadastro')).called(1);
      verifyNever(() => mockSnackbarHelper.showErrorSnackbar(any(), any()));
    },
  );
}

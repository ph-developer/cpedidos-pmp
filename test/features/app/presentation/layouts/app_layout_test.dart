import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:cpedidos_pmp/core/router/router.dart';
import 'package:cpedidos_pmp/features/app/presentation/layouts/app_layout.dart';
import 'package:cpedidos_pmp/features/auth/domain/entities/logged_user.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/get_current_user.dart';
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

  const tEmail = 'email';
  final tFailure = MockAuthFailure();
  const tLoggedUser = LoggedUser(id: 'id', email: tEmail);

  testWidgets(
    'should test app layout',
    (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      SnackbarHelper.delegate = mockSnackbarHelper;

      when(() => tFailure.message).thenReturn('fails');
      when(() => mockGetCurrentUser())
          .thenAnswer((_) async => const Success(tLoggedUser));
      when(() => router.go(any())).thenAnswer((_) {});
      when(() => mockDoLogout()).thenAnswer((_) async => Failure(tFailure));

      late Finder widget;

      await authStore.fetchLoggedUser();

      const testableLayout = MaterialApp(
        home: AppLayout(
          Text('test'),
          '/pedidos/cadastro',
        ),
      );

      await tester.pumpWidget(testableLayout);

      widget = find.bySubtype<AppLayout>();
      expect(widget, findsOneWidget);

      widget = find.text('test');
      expect(widget, findsOneWidget);

      tester.binding.window.physicalSizeTestValue = const Size(800, 600);

      widget = find.text('test');
      expect(widget, findsOneWidget);

      tester.binding.window.clearPhysicalSizeTestValue();

      widget = find.bySubtype<IconButton>();
      expect(widget, findsAtLeastNWidgets(1));

      widget = find.byIcon(Icons.logout_rounded);
      expect(widget, findsOneWidget);

      widget = find.text(tEmail);
      expect(widget, findsOneWidget);

      widget = find.bySubtype<IconButton>().first;
      await tester.tap(widget);
      verify(() => router.go(any())).called(1);

      widget = find.byTooltip('Sair');
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockDoLogout()).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      when(() => mockDoLogout()).thenAnswer((_) async => const Success(unit));

      widget = find.byTooltip('Sair');
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockDoLogout()).called(1);
      verify(() => router.go('/login')).called(1);
      verifyNever(() => mockSnackbarHelper.showErrorSnackbar(any(), any()));
    },
  );
}

import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:cpedidos_pmp/core/theme/theme.dart';
import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/features/orders/presentation/controllers/orders_search_controller.dart';
import 'package:cpedidos_pmp/features/orders/presentation/pages/orders_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IGetAllOrdersBySendDate mockGetAllOrdersBySendDate;
  late IGetAllOrdersByArrivalDate mockGetAllOrdersByArrivalDate;
  late SnackbarHelper mockSnackbarHelper;
  late OrdersSearchController controller;

  setUp(() {
    mockGetAllOrdersBySendDate = MockGetAllOrdersBySendDate();
    mockGetAllOrdersByArrivalDate = MockGetAllOrdersByArrivalDate();
    mockSnackbarHelper = MockSnackbarHelper();
    controller = OrdersSearchController(
      mockGetAllOrdersBySendDate,
      mockGetAllOrdersByArrivalDate,
    );

    registerFallbackValue(MockBuildContext());

    setupInjector((injector) async {
      injector
        ..removeAll()
        ..addInstance<OrdersSearchController>(controller)
        ..commit();
    });
  });

  const tQuery = '17/03/2023';
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  final tFailure = MockOrdersFailure();

  testWidgets(
    'should test orders search page',
    (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      SnackbarHelper.delegate = mockSnackbarHelper;

      when(() => tFailure.message).thenReturn('fails');
      when(() => mockGetAllOrdersBySendDate(''))
          .thenAnswer((_) async => Failure(tFailure));
      when(() => mockGetAllOrdersBySendDate(tQuery))
          .thenAnswer((_) async => const Success([tOrder]));

      late Finder widget;

      const testablePage = MaterialApp(
        home: Scaffold(
          body: OrdersSearchPage(),
        ),
      );

      await tester.pumpWidget(testablePage);

      widget = find.bySubtype<OrdersSearchPage>();
      expect(widget, findsOneWidget);

      widget = find.bySubtype<SelectInput>();
      expect(widget, findsOneWidget);

      widget = find.bySubtype<TextInput>();
      expect(widget, findsOneWidget);

      widget = find.bySubtype<OutlineButton>();
      expect(widget, findsNWidgets(2));

      widget = find.bySubtype<TextInput>();
      await tester.enterText(widget, '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      verify(() => mockGetAllOrdersBySendDate('')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.bySubtype<OutlineButton>().first;
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockGetAllOrdersBySendDate('')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.textContaining('Não foram encontrados pedidos');
      expect(widget, findsOneWidget);
      widget = find.bySubtype<Table>();
      expect(widget, findsNothing);

      widget = find.bySubtype<TextInput>();
      await tester.enterText(widget, tQuery);
      await tester.pump();

      widget = find.textContaining('Não foram encontrados pedidos');
      expect(widget, findsNothing);
      widget = find.bySubtype<Table>();
      expect(widget, findsNothing);

      widget = find.bySubtype<OutlineButton>().first;
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockGetAllOrdersBySendDate(tQuery)).called(1);
      verifyNever(() => mockSnackbarHelper.showErrorSnackbar(any(), any()));

      widget = find.textContaining('Não foram encontrados pedidos');
      expect(widget, findsNothing);
      widget = find.bySubtype<Table>();
      expect(widget, findsOneWidget);
      widget = find.text('type');
      expect(widget, findsOneWidget);
      widget = find.text('number');
      expect(widget, findsOneWidget);
      widget = find.text('secretary');
      expect(widget, findsOneWidget);
      widget = find.text('project');
      expect(widget, findsOneWidget);
      widget = find.text('description');
      expect(widget, findsOneWidget);

      widget = find.bySubtype<OutlineButton>().at(1);
      await tester.tap(widget);
      await tester.pump();
      verifyNever(() => mockGetAllOrdersBySendDate(tQuery));
      verifyNever(() => mockSnackbarHelper.showErrorSnackbar(any(), any()));

      widget = find.textContaining('Não foram encontrados pedidos');
      expect(widget, findsNothing);
      widget = find.bySubtype<Table>();
      expect(widget, findsNothing);
    },
  );
}

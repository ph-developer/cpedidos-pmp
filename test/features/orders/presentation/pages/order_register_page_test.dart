import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:cpedidos_pmp/core/theme/theme.dart';
import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/features/orders/presentation/controllers/order_register_controller.dart';
import 'package:cpedidos_pmp/features/orders/presentation/pages/order_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../helpers.dart';
import '../../../../mocks.dart';

void main() {
  late ISaveOrder mockSaveOrder;
  late IDeleteOrder mockDeleteOrder;
  late IGetOrderByTypeAndNumber mockGetOrderByTypeAndNumber;
  late SnackbarHelper mockSnackbarHelper;
  late OrderRegisterController controller;

  setUp(() {
    mockSaveOrder = MockSaveOrder();
    mockDeleteOrder = MockDeleteOrder();
    mockGetOrderByTypeAndNumber = MockGetOrderByTypeAndNumber();
    mockSnackbarHelper = MockSnackbarHelper();
    controller = OrderRegisterController(
      mockSaveOrder,
      mockDeleteOrder,
      mockGetOrderByTypeAndNumber,
    );

    registerFallbackValue(MockBuildContext());

    setupInjector((injector) async {
      injector
        ..removeAll()
        ..addInstance<OrderRegisterController>(controller)
        ..commit();
    });
  });

  const tNumber = '2023';
  const tOrder = Order(
    number: tNumber,
    type: 'SE',
    arrivalDate: '15/03/2023',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
    sendDate: '16/03/2023',
    returnDate: '17/03/2023',
    situation: 'situation',
    notes: 'notes',
  );
  const tArchivedNumber = '2021';
  const tArchivedOrder = Order(
    number: tArchivedNumber,
    type: 'SE',
    arrivalDate: '15/03/2021',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
    sendDate: '16/03/2021',
    returnDate: '17/03/2021',
    situation: 'situation',
    notes: 'notes',
    isArchived: true,
  );
  const tFailureNumber = '404';
  final tFailure = MockOrdersFailure();

  testWidgets(
    'should test order register page',
    (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      SnackbarHelper.delegate = mockSnackbarHelper;

      when(() => tFailure.message).thenReturn('fails');
      when(() => mockGetOrderByTypeAndNumber('SE', tFailureNumber))
          .thenAnswer((_) async => Failure(tFailure));
      when(() => mockGetOrderByTypeAndNumber('SE', tNumber))
          .thenAnswer((_) async => const Success(tOrder));
      when(() => mockGetOrderByTypeAndNumber('SE', tArchivedNumber))
          .thenAnswer((_) async => const Success(tArchivedOrder));
      when(() => mockSaveOrder(tOrder))
          .thenAnswer((_) async => const Success(tOrder));
      when(() => mockDeleteOrder(tOrder))
          .thenAnswer((_) async => const Success(unit));

      late Finder widget;

      const testablePage = MaterialApp(
        home: Scaffold(
          body: OrderRegisterPage(),
        ),
      );

      await tester.pumpWidget(testablePage);

      widget = find.bySubtype<OrderRegisterPage>();
      expect(widget, findsOneWidget);

      widget = find.bySubtype<TextInput>();
      expect(widget, findsNWidgets(7));
      expect((widget.evaluate().first.widget as TextInput).isEnabled, isTrue);
      widget.evaluate().skip(1).map((element) {
        expect((element.widget as TextInput).isEnabled, isFalse);
      });

      widget = find.bySubtype<SelectInput>();
      expect(widget, findsOneWidget);
      expect((widget.evaluate().first.widget as SelectInput).isEnabled, isTrue);

      widget = find.bySubtype<TextAreaInput>();
      expect(widget, findsNWidgets(2));
      widget.evaluate().map((element) {
        expect((element.widget as TextAreaInput).isEnabled, isFalse);
      });

      widget = find.bySubtype<OutlineButton>();
      expect(widget, findsNWidgets(3));
      widget.evaluate().map((element) {
        expect((element.widget as OutlineButton).isEnabled, isFalse);
      });

      widget = find.bySubtype<TextInput>().first;
      await tester.enterText(widget, tNumber);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      verify(() => mockGetOrderByTypeAndNumber('SE', tNumber)).called(1);

      widget = find.text('Este pedido está arquivado e não pode ser alterado.');
      expect(widget, findsNothing);
      widget = find.text(tOrder.arrivalDate);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isTrue);
      widget = find.text(tOrder.secretary);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isTrue);
      widget = find.text(tOrder.project);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isTrue);
      widget = find.text(tOrder.description);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextAreaInput>().isEnabled, isTrue);
      widget = find.text(tOrder.sendDate);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isTrue);
      widget = find.text(tOrder.returnDate);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isTrue);
      widget = find.text(tOrder.situation);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isTrue);
      widget = find.text(tOrder.notes);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextAreaInput>().isEnabled, isTrue);

      widget = find.bySubtype<OutlineButton>().first;
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockSaveOrder(tOrder)).called(1);
      verify(
        () => mockSnackbarHelper.showSuccessSnackbar(
          any(),
          'Pedido salvo com sucesso.',
        ),
      ).called(1);

      widget = find.bySubtype<OutlineButton>().at(2);
      await tester.tap(widget);
      await tester.pump();
      verifyNever(() => mockDeleteOrder(tOrder));

      widget = find.text('Excluir pedido?');
      expect(widget, findsOneWidget);
      widget = find.text(
        'Deseja realmente excluir este pedido? '
        'Esta ação é irreversível.',
      );
      expect(widget, findsOneWidget);
      widget = find.text('Sim');
      expect(widget, findsOneWidget);
      widget = find.text('Cancelar');
      expect(widget, findsOneWidget);

      widget = find.text('Cancelar');
      await tester.tap(widget);
      await tester.pump();
      verifyNever(() => mockDeleteOrder(tOrder));

      widget = find.bySubtype<OutlineButton>().at(2);
      await tester.tap(widget);
      await tester.pump();

      widget = find.text('Sim');
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockDeleteOrder(tOrder)).called(1);
      verify(
        () => mockSnackbarHelper.showSuccessSnackbar(
          any(),
          'Pedido excluído com sucesso.',
        ),
      ).called(1);

      widget = find.text('Este pedido está arquivado e não pode ser alterado.');
      expect(widget, findsNothing);
      widget = find.text(tOrder.arrivalDate);
      expect(widget, findsNothing);
      widget = find.text(tOrder.secretary);
      expect(widget, findsNothing);
      widget = find.text(tOrder.project);
      expect(widget, findsNothing);
      widget = find.text(tOrder.description);
      expect(widget, findsNothing);
      widget = find.text(tOrder.sendDate);
      expect(widget, findsNothing);
      widget = find.text(tOrder.returnDate);
      expect(widget, findsNothing);
      widget = find.text(tOrder.situation);
      expect(widget, findsNothing);
      widget = find.text(tOrder.notes);
      expect(widget, findsNothing);

      widget = find.bySubtype<TextInput>().first;
      await tester.enterText(widget, tFailureNumber);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      verify(() => mockGetOrderByTypeAndNumber('SE', tFailureNumber)).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.bySubtype<OutlineButton>().at(1);
      await tester.tap(widget);
      await tester.pump();
      verifyNever(() => mockGetOrderByTypeAndNumber('SE', ''));

      widget = find.text('Este pedido está arquivado e não pode ser alterado.');
      expect(widget, findsNothing);
      widget = find.text(tOrder.arrivalDate);
      expect(widget, findsNothing);
      widget = find.text(tOrder.secretary);
      expect(widget, findsNothing);
      widget = find.text(tOrder.project);
      expect(widget, findsNothing);
      widget = find.text(tOrder.description);
      expect(widget, findsNothing);
      widget = find.text(tOrder.sendDate);
      expect(widget, findsNothing);
      widget = find.text(tOrder.returnDate);
      expect(widget, findsNothing);
      widget = find.text(tOrder.situation);
      expect(widget, findsNothing);
      widget = find.text(tOrder.notes);
      expect(widget, findsNothing);

      widget = find.bySubtype<TextInput>().first;
      await tester.enterText(widget, tArchivedNumber);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      verify(() => mockGetOrderByTypeAndNumber('SE', tArchivedNumber))
          .called(1);

      widget = find.text('Este pedido está arquivado e não pode ser alterado.');
      expect(widget, findsOneWidget);
      widget = find.text(tArchivedOrder.arrivalDate);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.secretary);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.project);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.description);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextAreaInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.sendDate);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.returnDate);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.situation);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextInput>().isEnabled, isFalse);
      widget = find.text(tArchivedOrder.notes);
      expect(widget, findsOneWidget);
      expect(widget.getAncestor<TextAreaInput>().isEnabled, isFalse);
    },
  );
}

import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:cpedidos_pmp/core/theme/theme.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_material_by_code.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_group_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_service_by_code.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_group_description.dart';
import 'package:cpedidos_pmp/features/catalog/presentation/controllers/items_search_controller.dart';
import 'package:cpedidos_pmp/features/catalog/presentation/pages/items_search_page.dart';
import 'package:flutter/material.dart' hide Material;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IGetMaterialByCode mockGetMaterialByCode;
  late IGetMaterialsByDescription mockGetMaterialsByDescription;
  late IGetMaterialsByGroupDescription mockGetMaterialsByGroupDescription;
  late IGetServiceByCode mockGetServiceByCode;
  late IGetServicesByDescription mockGetServicesByDescription;
  late IGetServicesByGroupDescription mockGetServicesByGroupDescription;
  late SnackbarHelper mockSnackbarHelper;
  late ItemsSearchController controller;

  setUp(() {
    mockGetMaterialByCode = MockGetMaterialByCode();
    mockGetMaterialsByDescription = MockGetMaterialsByDescription();
    mockGetMaterialsByGroupDescription = MockGetMaterialsByGroupDescription();
    mockGetServiceByCode = MockGetServiceByCode();
    mockGetServicesByDescription = MockGetServicesByDescription();
    mockGetServicesByGroupDescription = MockGetServicesByGroupDescription();
    mockSnackbarHelper = MockSnackbarHelper();
    controller = ItemsSearchController(
      mockGetMaterialByCode,
      mockGetMaterialsByDescription,
      mockGetMaterialsByGroupDescription,
      mockGetServiceByCode,
      mockGetServicesByDescription,
      mockGetServicesByGroupDescription,
    );

    registerFallbackValue(MockBuildContext());

    setupInjector((injector) async {
      injector
        ..removeAll()
        ..addInstance<ItemsSearchController>(controller)
        ..commit();
    });
  });

  const tQuery = '12345';
  const tMaterial = Material(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  final tFailure = MockCatalogFailure();

  testWidgets(
    'should test items search page',
    (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      SnackbarHelper.delegate = mockSnackbarHelper;

      when(() => tFailure.message).thenReturn('fails');
      when(() => mockGetMaterialByCode(''))
          .thenAnswer((_) async => Failure(tFailure));
      when(() => mockGetMaterialByCode(tQuery))
          .thenAnswer((_) async => const Success(tMaterial));

      late Finder widget;

      const testablePage = MaterialApp(
        home: Scaffold(
          body: ItemsSearchPage(),
        ),
      );

      await tester.pumpWidget(testablePage);

      widget = find.bySubtype<ItemsSearchPage>();
      expect(widget, findsOneWidget);

      widget = find.bySubtype<SelectInput>();
      expect(widget, findsNWidgets(2));

      widget = find.bySubtype<TextInput>();
      expect(widget, findsOneWidget);

      widget = find.bySubtype<OutlineButton>();
      expect(widget, findsNWidgets(2));

      widget = find.bySubtype<TextInput>();
      await tester.enterText(widget, '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      verify(() => mockGetMaterialByCode('')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.bySubtype<OutlineButton>().first;
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockGetMaterialByCode('')).called(1);
      verify(() => mockSnackbarHelper.showErrorSnackbar(any(), 'fails'))
          .called(1);

      widget = find.textContaining('Não foram encontrados itens');
      expect(widget, findsOneWidget);
      widget = find.bySubtype<Table>();
      expect(widget, findsNothing);

      widget = find.bySubtype<TextInput>();
      await tester.enterText(widget, tQuery);
      await tester.pump();

      widget = find.textContaining('Não foram encontrados itens');
      expect(widget, findsNothing);
      widget = find.bySubtype<Table>();
      expect(widget, findsNothing);

      widget = find.bySubtype<OutlineButton>().first;
      await tester.tap(widget);
      await tester.pump();
      verify(() => mockGetMaterialByCode(tQuery)).called(1);

      widget = find.textContaining('Não foram encontrados itens');
      expect(widget, findsNothing);
      widget = find.bySubtype<Table>();
      expect(widget, findsOneWidget);
      widget = find.text('code');
      expect(widget, findsOneWidget);
      widget = find.text('description');
      expect(widget, findsOneWidget);
      widget = find.text('groupCode - groupDescription');
      expect(widget, findsOneWidget);

      widget = find.bySubtype<OutlineButton>().at(1);
      await tester.tap(widget);
      await tester.pump();
      verifyNever(() => mockGetMaterialByCode(tQuery));

      widget = find.textContaining('Não foram encontrados itens');
      expect(widget, findsNothing);
      widget = find.bySubtype<Table>();
      expect(widget, findsNothing);
    },
  );
}

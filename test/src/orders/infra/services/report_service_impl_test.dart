import 'dart:typed_data';

import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/infra/drivers/printer_driver.dart';
import 'package:cpedidos_pmp/src/orders/infra/services/report_service_impl.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late IErrorService mockErrorService;
  late IPrinterDriver mockPrinterDriver;
  late ReportServiceImpl service;

  setUp(() {
    mockErrorService = MockErrorService();
    mockPrinterDriver = MockPrinterDriver();
    service = ReportServiceImpl(mockErrorService, mockPrinterDriver);

    registerFallbackValue(Uint8List(0));
  });

  final tOrdersFailure = MockOrdersFailure();
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  const tOrderList = [tOrder];

  group('printOrdersReport', () {
    test(
      'should return an unit when success print.',
      () async {
        // arrange
        when(() => mockPrinterDriver.printPdfBytes(any()))
            .thenAnswer((_) async => true);
        // act
        final result = await service.printOrdersReport(tOrderList);
        // assert
        expect(result.getOrNull(), equals(unit));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(() => mockPrinterDriver.printPdfBytes(any()))
            .thenThrow(tOrdersFailure);
        // act
        final result = await service.printOrdersReport(tOrderList);
        // assert
        expect(result.exceptionOrNull(), equals(tOrdersFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockPrinterDriver.printPdfBytes(any()))
            .thenThrow(tException);
        when(() => mockErrorService.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await service.printOrdersReport(tOrderList);
        // assert
        verify(() => mockErrorService.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });
}

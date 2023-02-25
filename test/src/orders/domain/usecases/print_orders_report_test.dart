import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/services/pdf_service.dart';
import 'package:cpedidos_pmp/src/orders/domain/services/print_service.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/print_orders_report.dart';

class MockPdfService extends Mock implements IPdfService {}

class MockPrintService extends Mock implements IPrintService {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

void main() {
  late IPdfService mockPdfService;
  late IPrintService mockPrintService;
  late PrintOrdersReport usecase;

  setUp(() {
    mockPdfService = MockPdfService();
    mockPrintService = MockPrintService();
    usecase = PrintOrdersReport(mockPdfService, mockPrintService);
  });

  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  final tEmptyOrdersList = <Order>[];
  final tFilledOrdersList = [tOrder];
  final tEmptyBytes = Uint8List(0);
  final tOrdersFailure = MockOrdersFailure();

  test(
    'should return an Unit when success print.',
    () async {
      // arrange
      final tOrdersParam = tFilledOrdersList;
      when(() => mockPdfService.generateOrdersReport(tFilledOrdersList))
          .thenAnswer((_) async => Success(tEmptyBytes));
      when(() => mockPrintService.printPdfBytes(tEmptyBytes))
          .thenAnswer((_) async => const Success(unit));
      // act
      final result = await usecase(tOrdersParam);
      // assert
      expect(result.getOrNull(), unit);
    },
  );

  test(
    'should return an InvalidInput failure when orders param is empty.',
    () async {
      // arrange
      final tOrdersParam = tEmptyOrdersList;
      // act
      final result = await usecase(tOrdersParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an orders failure when pdf service returns an orders failure.',
    () async {
      // arrange
      final tOrdersParam = tFilledOrdersList;
      when(() => mockPdfService.generateOrdersReport(tFilledOrdersList))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tOrdersParam);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );

  test(
    'should return an orders failure when print service returns an orders failure.',
    () async {
      // arrange
      final tOrdersParam = tFilledOrdersList;
      when(() => mockPdfService.generateOrdersReport(tFilledOrdersList))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tOrdersParam);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

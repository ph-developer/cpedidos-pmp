import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/services/report_service.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/print_orders_report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IReportService mockReportService;
  late PrintOrdersReport usecase;

  setUp(() {
    mockReportService = MockReportService();
    usecase = PrintOrdersReport(mockReportService);
  });

  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  final tOrdersFailure = MockOrdersFailure();
  final tEmptyOrderList = <Order>[];
  final tOrderList = [tOrder];

  test(
    'should return an unit when success print.',
    () async {
      // arrange
      when(() => mockReportService.printOrdersReport(tOrderList))
          .thenAnswer((_) async => const Success(unit));
      // act
      final result = await usecase(tOrderList);
      // assert
      expect(result.getOrNull(), unit);
    },
  );

  test(
    'should return an InvalidInput failure when orders param is empty.',
    () async {
      // act
      final result = await usecase(tEmptyOrderList);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockReportService.printOrdersReport(tOrderList))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tOrderList);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

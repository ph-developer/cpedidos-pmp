import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_send_date.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

void main() {
  late IOrderRepo mockOrderRepo;
  late GetAllOrdersBySendDate usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = GetAllOrdersBySendDate(mockOrderRepo);
  });

  final tOrdersFailure = MockOrdersFailure();

  test(
    'should return a filled list when sendDate param is not empty and matches any order.',
    () async {
      // arrange
      const tSendDateParam = '02/02/2023';
      const tOrderList = [
        Order(
          number: 'number',
          type: 'type',
          sendDate: '02/02/2023',
          arrivalDate: 'arrivalDate',
          secretary: 'secretary',
          project: 'project',
          description: 'description',
        ),
      ];
      when(() => mockOrderRepo.getAllBySendDate(tSendDateParam))
          .thenAnswer((_) async => const Success(tOrderList));
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result.getOrNull(), equals(tOrderList));
    },
  );

  test(
    'should return an empty list when sendDate param is not empty and matches none order.',
    () async {
      // arrange
      const tSendDateParam = '02/02/2023';
      const List<Order> tOrderList = [];
      when(() => mockOrderRepo.getAllBySendDate(tSendDateParam))
          .thenAnswer((_) async => const Success(tOrderList));
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result.getOrNull(), equals(tOrderList));
    },
  );

  test(
    'should return an InvalidInput failure when sendDate param is empty.',
    () async {
      // arrange
      const tSendDateParam = '';
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an orders failure when order repo returns an orders failure.',
    () async {
      // arrange
      const tSendDateParam = '02/02/2023';
      when(() => mockOrderRepo.getAllBySendDate(tSendDateParam))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

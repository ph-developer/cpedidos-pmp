import 'package:cpedidos_pmp/src/orders/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

void main() {
  late IOrderRepo mockOrderRepo;
  late GetAllOrdersBySendDate usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = GetAllOrdersBySendDate(mockOrderRepo);
  });

  test(
    'should return a filled list when sendDate param is not empty and matches any order.',
    () async {
      // arrange
      const tSendDateParam = '02/02/2023';
      const tOrderList = [
        Order(number: 'number', type: 'type', sendDate: '02/02/2023'),
      ];
      when(() => mockOrderRepo.getAllBySendDate(tSendDateParam))
          .thenAnswer((_) async => tOrderList);
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result, isA<List<Order>>());
      expect(result, equals(tOrderList));
    },
  );

  test(
    'should return an empty list when sendDate param is not empty and matches none order.',
    () async {
      // arrange
      const tSendDateParam = '02/02/2023';
      const List<Order> tOrderList = [];
      when(() => mockOrderRepo.getAllBySendDate(tSendDateParam))
          .thenAnswer((_) async => tOrderList);
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result, isA<List<Order>>());
      expect(result, isEmpty);
    },
  );

  test(
    'should return an empty list when sendDate param is empty.',
    () async {
      // arrange
      const tSendDateParam = '';
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result, isA<List<Order>>());
      expect(result, isEmpty);
    },
  );

  test(
    'should return an empty array when repo throws a Failure.',
    () async {
      // arrange
      const tSendDateParam = '02/02/2023';
      final failure = GetAllBySendDateFailure();
      when(() => mockOrderRepo.getAllBySendDate(tSendDateParam))
          .thenThrow(failure);
      // act
      final result = await usecase(tSendDateParam);
      // assert
      expect(result, isEmpty);
    },
  );
}

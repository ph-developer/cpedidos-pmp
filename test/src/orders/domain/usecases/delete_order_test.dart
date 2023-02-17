import 'package:cpedidos_pmp/src/orders/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

void main() {
  late IOrderRepo mockOrderRepo;
  late DeleteOrder usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = DeleteOrder(mockOrderRepo);
  });

  test(
    'should return true on successfull delete.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: 'type');
      when(() => mockOrderRepo.delete(tOrderParam))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when order number param is empty.',
    () async {
      // arrange
      const tOrderParam = Order(number: '', type: 'type');
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isFalse);
    },
  );

  test(
    'should return false when order type param is empty.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: '');
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isFalse);
    },
  );

  test(
    'should return false on fail delete.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: 'type');
      when(() => mockOrderRepo.delete(tOrderParam))
          .thenAnswer((_) async => false);
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isFalse);
    },
  );

  test(
    'should return false when repo throws a Failure.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: 'type');
      final failure = DeleteFailure();
      when(() => mockOrderRepo.delete(tOrderParam)).thenThrow(failure);
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isFalse);
    },
  );
}

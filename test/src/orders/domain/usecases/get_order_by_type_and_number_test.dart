import 'package:cpedidos_pmp/src/orders/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

void main() {
  late IOrderRepo mockOrderRepo;
  late GetOrderByTypeAndNumber usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = GetOrderByTypeAndNumber(mockOrderRepo);
  });

  test(
    'should return an order when order exists.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = 'type';
      const tOrder = Order(number: 'number', type: 'type');
      when(() => mockOrderRepo.getByTypeAndNumber(tTypeParam, tNumberParam))
          .thenAnswer((_) async => tOrder);
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result, equals(tOrder));
    },
  );

  test(
    'should return null when order not exists.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = 'type';
      when(() => mockOrderRepo.getByTypeAndNumber(tTypeParam, tNumberParam))
          .thenAnswer((_) async => null);
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when number param is empty.',
    () async {
      // arrange
      const tNumberParam = '';
      const tTypeParam = 'type';
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when type param is empty.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = '';
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when repo throws a Failure.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = 'type';
      final failure = GetByTypeAndNumberFailure();
      when(() => mockOrderRepo.getByTypeAndNumber(tTypeParam, tNumberParam))
          .thenThrow(failure);
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result, isNull);
    },
  );
}

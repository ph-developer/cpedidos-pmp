import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_order_by_type_and_number.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

void main() {
  late IOrderRepo mockOrderRepo;
  late GetOrderByTypeAndNumber usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = GetOrderByTypeAndNumber(mockOrderRepo);
  });

  final tOrdersFailure = MockOrdersFailure();

  test(
    'should return an order when order exists.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = 'type';
      const tOrder = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      when(() => mockOrderRepo.getByTypeAndNumber(tTypeParam, tNumberParam))
          .thenAnswer((_) async => const Success(tOrder));
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result.getOrNull(), equals(tOrder));
    },
  );

  test(
    'should return an InvalidInput failure when number param is empty.',
    () async {
      // arrange
      const tNumberParam = '';
      const tTypeParam = 'type';
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when type param is empty.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = '';
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an orders failure when order repo returns an orders failure.',
    () async {
      // arrange
      const tNumberParam = 'number';
      const tTypeParam = 'type';
      when(() => mockOrderRepo.getByTypeAndNumber(tTypeParam, tNumberParam))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tTypeParam, tNumberParam);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

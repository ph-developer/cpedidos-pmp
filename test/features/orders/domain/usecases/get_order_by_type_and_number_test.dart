import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IOrderRepository mockOrderRepository;
  late GetOrderByTypeAndNumberImpl usecase;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    usecase = GetOrderByTypeAndNumberImpl(mockOrderRepository);
  });

  final tOrdersFailure = MockOrdersFailure();
  const tNumber = 'number';
  const tType = 'type';
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );

  test(
    'should return an order when order exists.',
    () async {
      // arrange
      when(() => mockOrderRepository.getOrderByTypeAndNumber(tType, tNumber))
          .thenAnswer((_) async => const Success(tOrder));
      // act
      final result = await usecase(tType, tNumber);
      // assert
      expect(result.getOrNull(), equals(tOrder));
    },
  );

  test(
    'should return an InvalidInput failure when number param is empty.',
    () async {
      // act
      final result = await usecase(tType, '');
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when type param is empty.',
    () async {
      // act
      final result = await usecase('', tNumber);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      const tNumber = 'number';
      const tType = 'type';
      when(() => mockOrderRepository.getOrderByTypeAndNumber(tType, tNumber))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tType, tNumber);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

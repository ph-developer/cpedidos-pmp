import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/save_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IOrderRepository mockOrderRepository;
  late SaveOrder usecase;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    usecase = SaveOrder(mockOrderRepository);
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

  test(
    'should return an order on successfull saving.',
    () async {
      // arrange
      when(() => mockOrderRepository.saveOrder(tOrder))
          .thenAnswer((_) async => const Success(tOrder));
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.getOrNull(), equals(tOrder));
    },
  );

  test(
    'should return an InvalidInput failure when number param is empty.',
    () async {
      // arrange
      const tOrder = Order(
        number: '',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when type param is empty.',
    () async {
      // arrange
      const tOrder = Order(
        number: 'number',
        type: '',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when arrivalDate param is empty.',
    () async {
      // arrange
      const tOrder = Order(
        number: 'number',
        type: 'type',
        arrivalDate: '',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when secretary param is empty.',
    () async {
      // arrange
      const tOrder = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: '',
        project: 'project',
        description: 'description',
      );
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when project param is empty.',
    () async {
      // arrange
      const tOrder = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: '',
        description: 'description',
      );
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when description param is empty.',
    () async {
      // arrange
      const tOrder = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: '',
      );
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockOrderRepository.saveOrder(tOrder))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

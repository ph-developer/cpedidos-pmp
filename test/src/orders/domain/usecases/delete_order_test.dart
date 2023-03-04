import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IOrderRepository mockOrderRepository;
  late DeleteOrder usecase;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    usecase = DeleteOrder(mockOrderRepository);
  });

  final tOrdersFailure = MockOrdersFailure();
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: '01/03/2023',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );

  test(
    'should return an unit on successfull delete.',
    () async {
      // arrange
      when(() => mockOrderRepository.deleteOrder(tOrder))
          .thenAnswer((_) async => const Success(unit));
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.getOrNull(), equals(unit));
    },
  );

  // test(
  //   'should return an InvalidInput failure when number param is empty.',
  //   () async {
  //     // act
  //     final result = await usecase(tType, '');
  //     // assert
  //     expect(result.exceptionOrNull(), isA<InvalidInput>());
  //   },
  // );

  // test(
  //   'should return an InvalidInput failure when type param is empty.',
  //   () async {
  //     // act
  //     final result = await usecase('', tNumber);
  //     // assert
  //     expect(result.exceptionOrNull(), isA<InvalidInput>());
  //   },
  // );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockOrderRepository.deleteOrder(tOrder))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tOrder);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

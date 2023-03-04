import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IOrderRepository mockOrderRepository;
  late GetAllOrdersByArrivalDate usecase;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    usecase = GetAllOrdersByArrivalDate(mockOrderRepository);
  });

  final tOrdersFailure = MockOrdersFailure();
  const tArrivalDate = 'arrivalDate';
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  const tOrderList = [tOrder];
  const tEmptyOrderList = <Order>[];

  test(
    'should return a filled list when find any order.',
    () async {
      // arrange
      when(() => mockOrderRepository.getAllOrdersByArrivalDate(tArrivalDate))
          .thenAnswer((_) async => const Success(tOrderList));
      // act
      final result = await usecase(tArrivalDate);
      // assert
      expect(result.getOrNull(), equals(tOrderList));
    },
  );

  test(
    'should return an empty list when not find any order.',
    () async {
      // arrange
      when(() => mockOrderRepository.getAllOrdersByArrivalDate(tArrivalDate))
          .thenAnswer((_) async => const Success(tEmptyOrderList));
      // act
      final result = await usecase(tArrivalDate);
      // assert
      expect(result.getOrNull(), equals(tEmptyOrderList));
    },
  );

  test(
    'should return an InvalidInput failure when arrivalDate param is empty.',
    () async {
      // act
      final result = await usecase('');
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(() => mockOrderRepository.getAllOrdersByArrivalDate(tArrivalDate))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tArrivalDate);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

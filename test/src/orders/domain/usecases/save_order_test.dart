import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/orders/data/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/save_order.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

void main() {
  late IOrderRepo mockOrderRepo;
  late SaveOrder usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = SaveOrder(mockOrderRepo);
  });

  test(
    'should return an order on successfull saving.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: 'type');
      when(() => mockOrderRepo.save(tOrderParam))
          .thenAnswer((_) async => tOrderParam);
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, equals(tOrderParam));
    },
  );

  test(
    'should return null order number param is empty.',
    () async {
      // arrange
      const tOrderParam = Order(number: '', type: 'type');
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when order type param is empty.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: '');
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isNull);
    },
  );

  test(
    'should return null when repo throws a Failure.',
    () async {
      // arrange
      const tOrderParam = Order(number: 'number', type: 'type');
      final failure = SaveFailure();
      when(() => mockOrderRepo.save(tOrderParam)).thenThrow(failure);
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result, isNull);
    },
  );
}

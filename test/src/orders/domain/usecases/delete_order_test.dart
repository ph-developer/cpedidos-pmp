import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockOrderRepo extends Mock implements IOrderRepo {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

void main() {
  late IOrderRepo mockOrderRepo;
  late DeleteOrder usecase;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    usecase = DeleteOrder(mockOrderRepo);
  });

  final tOrdersFailure = MockOrdersFailure();

  test(
    'should return true on successfull delete.',
    () async {
      // arrange
      const tOrderParam = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      when(() => mockOrderRepo.delete(tOrderParam))
          .thenAnswer((_) async => const Success(true));
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result.getOrNull(), isTrue);
    },
  );

  test(
    'should return an InvalidInput failure when order number param is empty.',
    () async {
      // arrange
      const tOrderParam = Order(
        number: '',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an InvalidInput failure when order type param is empty.',
    () async {
      // arrange
      const tOrderParam = Order(
        number: 'number',
        type: '',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return an orders failure when order repo returns an orders failure.',
    () async {
      // arrange
      const tOrderParam = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      when(() => mockOrderRepo.delete(tOrderParam))
          .thenAnswer((_) async => Failure(tOrdersFailure));
      // act
      final result = await usecase(tOrderParam);
      // assert
      expect(result.exceptionOrNull(), equals(tOrdersFailure));
    },
  );
}

import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return true when all order props are equals.',
    () async {
      // arrange
      const tOrderA = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      const tOrderB = Order(
        number: 'number',
        type: 'type',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = tOrderA == tOrderB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any order prop are different.',
    () async {
      // arrange
      const tOrderA = Order(
        number: 'number',
        type: 'type1',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      const tOrderB = Order(
        number: 'number',
        type: 'type2',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      );
      // act
      final result = tOrderA == tOrderB;
      // assert
      expect(result, isFalse);
    },
  );
}

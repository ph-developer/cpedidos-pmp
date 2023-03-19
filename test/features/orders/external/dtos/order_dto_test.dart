import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/external/dtos/order_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
    sendDate: 'sendDate',
    returnDate: 'returnDate',
    situation: 'situation',
    notes: 'notes',
  );
  const tOrderMap = {
    'number': 'number',
    'type': 'type',
    'arrivalDate': 'arrivalDate',
    'secretary': 'secretary',
    'project': 'project',
    'description': 'description',
    'sendDate': 'sendDate',
    'returnDate': 'returnDate',
    'situation': 'situation',
    'notes': 'notes',
  };

  group('toMap', () {
    test(
      'should convert an order entity to a map.',
      () async {
        // act
        final result = tOrder.toMap();
        // assert
        expect(result, isA<Map>());
        expect(result, equals(tOrderMap));
      },
    );
  });

  group('fromMap', () {
    test(
      'should conver a map to an order entity.',
      () async {
        // act
        final result = OrderDTO.fromMap(tOrderMap);
        // assert
        expect(result, isA<Order>());
        expect(result, equals(tOrder));
      },
    );
  });
}

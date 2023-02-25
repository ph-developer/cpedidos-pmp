import 'package:cpedidos_pmp/src/orders/domain/dtos/order_dto.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('copyWith', () {
    test(
      'should make an order copy with none field changed.',
      () async {
        // arrange
        const tOrder = Order(
          number: 'number',
          type: 'type',
          arrivalDate: 'arrivalDate',
          secretary: 'secretary',
          project: 'project',
          description: 'description',
        );
        // act
        final result = tOrder.copyWith();
        // assert
        expect(result.number, equals(tOrder.number));
        expect(result.type, equals(tOrder.type));
        expect(result.arrivalDate, equals(tOrder.arrivalDate));
        expect(result.secretary, equals(tOrder.secretary));
        expect(result.project, equals(tOrder.project));
        expect(result.description, equals(tOrder.description));
        expect(result.sendDate, equals(tOrder.sendDate));
        expect(result.returnDate, equals(tOrder.returnDate));
        expect(result.situation, equals(tOrder.situation));
        expect(result.notes, equals(tOrder.notes));
      },
    );

    test(
      'should make an order copy with all fields changed.',
      () async {
        // arrange
        const tOrder = Order(
          number: 'number',
          type: 'type',
          arrivalDate: 'arrivalDate',
          secretary: 'secretary',
          project: 'project',
          description: 'description',
        );
        // act
        final result = tOrder.copyWith(
          number: 'new_number',
          type: 'new_type',
          arrivalDate: 'new_arrivalDate',
          secretary: 'new_secretary',
          project: 'new_project',
          description: 'new_description',
          sendDate: 'new_sendDate',
          returnDate: 'new_returnDate',
          situation: 'new_situation',
          notes: 'new_notes',
        );
        // assert
        expect(result.number, equals('new_number'));
        expect(result.type, equals('new_type'));
        expect(result.arrivalDate, equals('new_arrivalDate'));
        expect(result.secretary, equals('new_secretary'));
        expect(result.project, equals('new_project'));
        expect(result.description, equals('new_description'));
        expect(result.sendDate, equals('new_sendDate'));
        expect(result.returnDate, equals('new_returnDate'));
        expect(result.situation, equals('new_situation'));
        expect(result.notes, equals('new_notes'));
      },
    );
  });

  group('empty', () {
    test(
      'should return an empty order.',
      () async {
        // arrange
        const tEmptyOrder = Order(
          number: '',
          type: 'SE',
          arrivalDate: '',
          secretary: '',
          project: '',
          description: '',
        );
        // act
        final result = OrderDTO.empty();
        // assert
        expect(result, equals(tEmptyOrder));
      },
    );
  });
}

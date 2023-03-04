import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/external/decorators/order_datasource_decorator.dart';
import 'package:cpedidos_pmp/src/orders/infra/datasources/order_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late IOrderDatasource mockOrderDatasource;
  late OrderDatasourceDecorator decorator;

  setUp(() {
    mockOrderDatasource = MockOrderDatasource();
    decorator = OrderDatasourceDecorator(mockOrderDatasource);
  });

  const tType = 'type';
  const tNumber = 'number';
  const tSendDate = 'sendDate';
  const tArrivalDate = 'arrivalDate';
  const tOrder = Order(
    number: tNumber,
    type: tType,
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
    sendDate: 'sendDate',
    returnDate: 'returnDate',
    situation: 'situation',
    notes: 'notes',
  );
  const tOrderList = [tOrder];

  group('getOrderByTypeAndNumber', () {
    test(
      'should just return decoratee getOrderByTypeAndNumber result.',
      () async {
        // arrange
        when(() => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber))
            .thenAnswer((_) async => tOrder);
        // act
        final result = await decorator.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(result, equals(tOrder));
        verify(
          () => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );
  });

  group('getAllOrdersBySendDate', () {
    test(
      'should just return decoratee getAllOrdersBySendDate result.',
      () async {
        // arrange
        when(() => mockOrderDatasource.getAllOrdersBySendDate(tSendDate))
            .thenAnswer((_) async => tOrderList);
        // act
        final result = await decorator.getAllOrdersBySendDate(tSendDate);
        // assert
        expect(result, equals(tOrderList));
        verify(
          () => mockOrderDatasource.getAllOrdersBySendDate(tSendDate),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );
  });

  group('getAllOrdersByArrivalDate', () {
    test(
      'should just return decoratee getAllOrdersByArrivalDate result.',
      () async {
        // arrange
        when(() => mockOrderDatasource.getAllOrdersByArrivalDate(tArrivalDate))
            .thenAnswer((_) async => tOrderList);
        // act
        final result = await decorator.getAllOrdersByArrivalDate(tArrivalDate);
        // assert
        expect(result, equals(tOrderList));
        verify(
          () => mockOrderDatasource.getAllOrdersByArrivalDate(tArrivalDate),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );
  });

  group('saveOrder', () {
    test(
      'should just return decoratee saveOrder result.',
      () async {
        // arrange
        when(() => mockOrderDatasource.saveOrder(tOrder))
            .thenAnswer((_) async => tOrder);
        // act
        final result = await decorator.saveOrder(tOrder);
        // assert
        expect(result, equals(tOrder));
        verify(
          () => mockOrderDatasource.saveOrder(tOrder),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );
  });

  group('deleteOrder', () {
    test(
      'should just return decoratee deleteOrder result.',
      () async {
        // arrange
        when(() => mockOrderDatasource.deleteOrder(tOrder))
            .thenAnswer((_) async => true);
        // act
        final result = await decorator.deleteOrder(tOrder);
        // assert
        expect(result, isTrue);
        verify(
          () => mockOrderDatasource.deleteOrder(tOrder),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );
  });
}

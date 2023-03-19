import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/features/orders/presentation/controllers/order_register_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late ISaveOrder mockSaveOrder;
  late IDeleteOrder mockDeleteOrder;
  late IGetOrderByTypeAndNumber mockGetOrderByTypeAndNumber;
  late OrderRegisterController controller;

  setUp(() {
    mockSaveOrder = MockSaveOrder();
    mockDeleteOrder = MockDeleteOrder();
    mockGetOrderByTypeAndNumber = MockGetOrderByTypeAndNumber();
    controller = OrderRegisterController(
      mockSaveOrder,
      mockDeleteOrder,
      mockGetOrderByTypeAndNumber,
    )..toString();
  });

  const tNumber = 'number';
  const tType = 'type';
  const tPayload = {'type': tType, 'number': tNumber};
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
  const tOrderPayload = {
    'number': tNumber,
    'type': tType,
    'arrivalDate': 'arrivalDate',
    'secretary': 'secretary',
    'project': 'project',
    'description': 'description',
    'sendDate': 'sendDate',
    'returnDate': 'returnDate',
    'situation': 'situation',
    'notes': 'notes',
  };
  final tFailure = MockOrdersFailure();

  group('clearSearch', () {
    test(
      'should clear last search.',
      () async {
        // arrange
        controller
          ..loadedOrder = tOrder
          ..currentQuery = tPayload
          ..isLoaded = true;
        // act
        await controller.clearSearch();
        // assert
        expect(controller.loadedOrder, isNull);
        expect(controller.currentQuery, isNull);
        expect(controller.isLoaded, isFalse);
      },
    );
  });

  group('searchOrder', () {
    test(
      'should set order when order exists.',
      () async {
        // arrange
        when(() => mockGetOrderByTypeAndNumber(tType, tNumber))
            .thenAnswer((_) async => const Success(tOrder));
        // act
        await controller.searchOrder(tPayload);
        await mobx.asyncWhen((_) => controller.isSearching == true);
        await mobx.asyncWhen((_) => controller.isSearching == false);
        // assert
        expect(controller.loadedOrder, equals(tOrder));
        expect(controller.currentQuery, equals(tPayload));
        expect(controller.isLoaded, isTrue);
      },
    );

    test(
      'should unset order when order not exists.',
      () async {
        // arrange
        controller
          ..loadedOrder = tOrder
          ..currentQuery = tPayload
          ..isLoaded = true;
        when(() => mockGetOrderByTypeAndNumber(tType, tNumber))
            .thenAnswer((_) async => const Failure(OrderNotFound()));
        // act
        await controller.searchOrder(tPayload);
        await mobx.asyncWhen((_) => controller.isSearching == true);
        await mobx.asyncWhen((_) => controller.isSearching == false);
        // assert
        expect(controller.loadedOrder, isNull);
        expect(controller.currentQuery, equals(tPayload));
        expect(controller.isLoaded, isTrue);
      },
    );

    test(
      'should set failure when usecase returns a failure.',
      () async {
        // arrange
        when(() => mockGetOrderByTypeAndNumber(tType, tNumber))
            .thenAnswer((_) async => Failure(tFailure));
        // act
        await controller.searchOrder(tPayload);
        await mobx.asyncWhen((_) => controller.isSearching == true);
        await mobx.asyncWhen((_) => controller.isSearching == false);
        // assert
        expect(controller.loadedOrder, isNull);
        expect(controller.isLoaded, isFalse);
        expect(controller.failure, equals(tFailure));
      },
    );
  });

  group('saveOrder', () {
    group('when order not exists', () {
      test(
        'should save order and set success.',
        () async {
          // arrange
          controller
            ..currentQuery = tPayload
            ..isLoaded = true;
          when(() => mockSaveOrder(tOrder))
              .thenAnswer((_) async => const Success(tOrder));
          // act
          await controller.saveOrder(tOrderPayload);
          // assert
          expect(controller.loadedOrder, equals(tOrder));
          expect(controller.isLoaded, isTrue);
          expect(controller.success, equals(SuccessfulAction.save));
        },
      );

      test(
        'should set failure when usecase returns a failure.',
        () async {
          // arrange
          controller
            ..currentQuery = tPayload
            ..isLoaded = true;
          when(() => mockSaveOrder(tOrder))
              .thenAnswer((_) async => Failure(tFailure));
          // act
          await controller.saveOrder(tOrderPayload);
          // assert
          expect(controller.loadedOrder, isNull);
          expect(controller.isLoaded, isTrue);
          expect(controller.failure, equals(tFailure));
        },
      );
    });

    group('when order exists', () {
      test(
        'should save order and set success.',
        () async {
          // arrange
          controller
            ..loadedOrder = tOrder
            ..currentQuery = tPayload
            ..isLoaded = true;
          when(() => mockSaveOrder(tOrder))
              .thenAnswer((_) async => const Success(tOrder));
          // act
          await controller.saveOrder(tOrderPayload);
          // assert
          expect(controller.loadedOrder, equals(tOrder));
          expect(controller.isLoaded, isTrue);
          expect(controller.success, equals(SuccessfulAction.save));
        },
      );

      test(
        'should set failure when usecase returns a failure.',
        () async {
          // arrange
          controller
            ..loadedOrder = tOrder
            ..currentQuery = tPayload
            ..isLoaded = true;
          when(() => mockSaveOrder(tOrder))
              .thenAnswer((_) async => Failure(tFailure));
          // act
          await controller.saveOrder(tOrderPayload);
          // assert
          expect(controller.loadedOrder, equals(tOrder));
          expect(controller.isLoaded, isTrue);
          expect(controller.failure, equals(tFailure));
        },
      );
    });
  });

  group('deleteOrder', () {
    test(
      'should delete order and set success.',
      () async {
        // arrange
        controller
          ..loadedOrder = tOrder
          ..currentQuery = tPayload
          ..isLoaded = true;
        when(() => mockDeleteOrder(tOrder))
            .thenAnswer((_) async => const Success(unit));
        // act
        await controller.deleteOrder(tOrderPayload);
        // assert
        expect(controller.loadedOrder, isNull);
        expect(controller.isLoaded, isTrue);
        expect(controller.success, equals(SuccessfulAction.delete));
      },
    );

    test(
      'should set failure when usecase returns a failure.',
      () async {
        // arrange
        controller
          ..loadedOrder = tOrder
          ..currentQuery = tPayload
          ..isLoaded = true;
        when(() => mockDeleteOrder(tOrder))
            .thenAnswer((_) async => Failure(tFailure));
        // act
        await controller.deleteOrder(tOrderPayload);
        // assert
        expect(controller.loadedOrder, tOrder);
        expect(controller.isLoaded, isTrue);
        expect(controller.failure, equals(tFailure));
      },
    );
  });
}

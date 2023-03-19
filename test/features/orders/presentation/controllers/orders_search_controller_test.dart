import 'package:cpedidos_pmp/core/reactivity/obs_paginated_list.dart';
import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/features/orders/presentation/controllers/orders_search_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IGetAllOrdersBySendDate mockGetAllOrdersBySendDate;
  late IGetAllOrdersByArrivalDate mockGetAllOrdersByArrivalDate;
  late OrdersSearchController controller;

  setUp(() {
    mockGetAllOrdersBySendDate = MockGetAllOrdersBySendDate();
    mockGetAllOrdersByArrivalDate = MockGetAllOrdersByArrivalDate();
    controller = OrdersSearchController(
      mockGetAllOrdersBySendDate,
      mockGetAllOrdersByArrivalDate,
    )..toString();
  });

  const tQuery = 'query';
  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  const tOrderList = [tOrder];
  final tFailure = MockOrdersFailure();

  group('clearSearch', () {
    test(
      'should clear loaded orders and set loaded as false.',
      () async {
        // arrange
        controller
          ..loadedOrders = ObservablePaginatedList.of(tOrderList)
          ..isLoaded = true;
        expect(controller.loadedOrders.length, tOrderList.length);
        expect(controller.isLoaded, isTrue);
        // act
        await controller.clearSearch();
        // assert
        expect(controller.loadedOrders.length, equals(0));
        expect(controller.isLoaded, isFalse);
      },
    );
  });

  group('searchOrders', () {
    group('when searchType is "sendDate"', () {
      test(
        'should set loaded orders if some order is found.',
        () async {
          // arrange
          when(() => mockGetAllOrdersBySendDate(tQuery))
              .thenAnswer((_) async => const Success(tOrderList));
          // act
          await controller.searchOrders({
            'searchType': 'sendDate',
            'query': tQuery,
          });
          // assert
          expect(controller.loadedOrders.all, equals(tOrderList));
          expect(controller.isLoaded, isTrue);
        },
      );

      test(
        'should set empty loaded orders if no one order is found.',
        () async {
          // arrange
          when(() => mockGetAllOrdersBySendDate(tQuery))
              .thenAnswer((_) async => const Success([]));
          // act
          await controller.searchOrders({
            'searchType': 'sendDate',
            'query': tQuery,
          });
          // assert
          expect(controller.loadedOrders.all, equals([]));
          expect(controller.isLoaded, isTrue);
        },
      );

      test(
        'should set failure when usecase returns a failure.',
        () async {
          // arrange
          when(() => mockGetAllOrdersBySendDate(tQuery))
              .thenAnswer((_) async => Failure(tFailure));
          // act
          await controller.searchOrders({
            'searchType': 'sendDate',
            'query': tQuery,
          });
          // assert
          expect(controller.loadedOrders.all, equals([]));
          expect(controller.isLoaded, isTrue);
          expect(controller.failure, equals(tFailure));
        },
      );
    });

    group('when searchType is "arrivalDate"', () {
      test(
        'should set loaded orders if some order is found.',
        () async {
          // arrange
          when(() => mockGetAllOrdersByArrivalDate(tQuery))
              .thenAnswer((_) async => const Success(tOrderList));
          // act
          await controller.searchOrders({
            'searchType': 'arrivalDate',
            'query': tQuery,
          });
          // assert
          expect(controller.loadedOrders.all, equals(tOrderList));
          expect(controller.isLoaded, isTrue);
        },
      );

      test(
        'should set empty loaded orders if no one order is found.',
        () async {
          // arrange
          when(() => mockGetAllOrdersByArrivalDate(tQuery))
              .thenAnswer((_) async => const Success([]));
          // act
          await controller.searchOrders({
            'searchType': 'arrivalDate',
            'query': tQuery,
          });
          // assert
          expect(controller.loadedOrders.all, equals([]));
          expect(controller.isLoaded, isTrue);
        },
      );

      test(
        'should set failure when usecase returns a failure.',
        () async {
          // arrange
          when(() => mockGetAllOrdersByArrivalDate(tQuery))
              .thenAnswer((_) async => Failure(tFailure));
          // act
          await controller.searchOrders({
            'searchType': 'arrivalDate',
            'query': tQuery,
          });
          // assert
          expect(controller.loadedOrders.all, equals([]));
          expect(controller.isLoaded, isTrue);
          expect(controller.failure, equals(tFailure));
        },
      );
    });
  });
}

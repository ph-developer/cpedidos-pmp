import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../mocks.dart';

void main() {
  late IGetAllOrdersBySendDate mockGetAllOrdersBySendDate;
  late IGetAllOrdersByArrivalDate mockGetAllOrdersByArrivalDate;

  setUp(() {
    mockGetAllOrdersBySendDate = MockGetAllOrdersBySendDate();
    mockGetAllOrdersByArrivalDate = MockGetAllOrdersByArrivalDate();
  });

  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  const tEmptyOrdersList = <Order>[];
  const tFilledOrdersList = [tOrder];
  final tOrdersFailure = MockOrdersFailure();

  group('reset', () {
    blocTest<OrdersSearchCubit, OrdersSearchState>(
      'should emits [InitialState] when called.',
      build: () => OrdersSearchCubit(
        mockGetAllOrdersBySendDate,
        mockGetAllOrdersByArrivalDate,
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [InitialState()],
    );
  });

  group('setDirty', () {
    blocTest<OrdersSearchCubit, OrdersSearchState>(
      'should emits [DirtyState] when called.',
      build: () => OrdersSearchCubit(
        mockGetAllOrdersBySendDate,
        mockGetAllOrdersByArrivalDate,
      ),
      act: (cubit) => cubit.setDirty(),
      expect: () => [DirtyState()],
    );
  });

  group('search', () {
    group('searchType == "sendDate"', () {
      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emits [LoadingState, LoadedState] when find orders.',
        setUp: () {
          when(() => mockGetAllOrdersBySendDate(any()))
              .thenAnswer((_) async => const Success(tFilledOrdersList));
        },
        build: () => OrdersSearchCubit(
          mockGetAllOrdersBySendDate,
          mockGetAllOrdersByArrivalDate,
        ),
        act: (cubit) => cubit.search('sendDate', 'date'),
        expect: () => [
          LoadingState(),
          LoadedState(orders: tFilledOrdersList),
        ],
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emits [LoadingState, LoadedState] when not find orders.',
        setUp: () {
          when(() => mockGetAllOrdersBySendDate(any()))
              .thenAnswer((_) async => const Success(tEmptyOrdersList));
        },
        build: () => OrdersSearchCubit(
          mockGetAllOrdersBySendDate,
          mockGetAllOrdersByArrivalDate,
        ),
        act: (cubit) => cubit.search('sendDate', 'date'),
        expect: () => [
          LoadingState(),
          LoadedState(orders: tEmptyOrdersList),
        ],
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emits [LoadingState, FailureState] when usecase return a '
        'failure (not OrdersNotFound).',
        setUp: () {
          when(() => mockGetAllOrdersBySendDate(any()))
              .thenAnswer((_) async => Failure(tOrdersFailure));
        },
        build: () => OrdersSearchCubit(
          mockGetAllOrdersBySendDate,
          mockGetAllOrdersByArrivalDate,
        ),
        act: (cubit) => cubit.search('sendDate', 'date'),
        expect: () => [
          LoadingState(),
          FailureState(failure: tOrdersFailure),
        ],
      );
    });

    group('searchType == "arrivalDate"', () {
      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emits [LoadingState, LoadedState] when find orders.',
        setUp: () {
          when(() => mockGetAllOrdersByArrivalDate(any()))
              .thenAnswer((_) async => const Success(tFilledOrdersList));
        },
        build: () => OrdersSearchCubit(
          mockGetAllOrdersBySendDate,
          mockGetAllOrdersByArrivalDate,
        ),
        act: (cubit) => cubit.search('arrivalDate', 'date'),
        expect: () => [
          LoadingState(),
          LoadedState(orders: tFilledOrdersList),
        ],
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emits [LoadingState, LoadedState] when not find orders.',
        setUp: () {
          when(() => mockGetAllOrdersByArrivalDate(any()))
              .thenAnswer((_) async => const Success(tEmptyOrdersList));
        },
        build: () => OrdersSearchCubit(
          mockGetAllOrdersBySendDate,
          mockGetAllOrdersByArrivalDate,
        ),
        act: (cubit) => cubit.search('arrivalDate', 'date'),
        expect: () => [
          LoadingState(),
          LoadedState(orders: tEmptyOrdersList),
        ],
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emits [LoadingState, FailureState] when usecase return a '
        'failure (not OrdersNotFound).',
        setUp: () {
          when(() => mockGetAllOrdersByArrivalDate(any()))
              .thenAnswer((_) async => Failure(tOrdersFailure));
        },
        build: () => OrdersSearchCubit(
          mockGetAllOrdersBySendDate,
          mockGetAllOrdersByArrivalDate,
        ),
        act: (cubit) => cubit.search('arrivalDate', 'date'),
        expect: () => [
          LoadingState(),
          FailureState(failure: tOrdersFailure),
        ],
      );
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_report_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_report_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockGetAllOrdersBySendDate extends Mock
    implements IGetAllOrdersBySendDate {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

void main() {
  late IGetAllOrdersBySendDate mockGetAllOrdersBySendDate;

  setUp(() {
    mockGetAllOrdersBySendDate = MockGetAllOrdersBySendDate();
  });

  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  final tEmptyOrdersList = <Order>[];
  final tFilledOrdersList = [tOrder];
  final tOrdersFailure = MockOrdersFailure();

  group('reset', () {
    blocTest<OrdersReportCubit, OrdersReportState>(
      'should emits [InitialState] when called.',
      build: () => OrdersReportCubit(
        mockGetAllOrdersBySendDate,
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [InitialState()],
    );
  });

  group('setDirty', () {
    blocTest<OrdersReportCubit, OrdersReportState>(
      'should emits [DirtyState] when called.',
      build: () => OrdersReportCubit(
        mockGetAllOrdersBySendDate,
      ),
      act: (cubit) => cubit.setDirty(),
      expect: () => [DirtyState()],
    );
  });

  group('search', () {
    blocTest<OrdersReportCubit, OrdersReportState>(
      'should emits [LoadingState, LoadedState] when find orders.',
      setUp: () {
        when(() => mockGetAllOrdersBySendDate(any()))
            .thenAnswer((_) async => Success(tFilledOrdersList));
      },
      build: () => OrdersReportCubit(
        mockGetAllOrdersBySendDate,
      ),
      act: (cubit) => cubit.search('date'),
      expect: () => [
        LoadingState(),
        LoadedState(orders: tFilledOrdersList),
      ],
    );

    blocTest<OrdersReportCubit, OrdersReportState>(
      'should emits [LoadingState, LoadedState] when not find orders.',
      setUp: () {
        when(() => mockGetAllOrdersBySendDate(any()))
            .thenAnswer((_) async => const Failure(OrdersNotFound()));
      },
      build: () => OrdersReportCubit(
        mockGetAllOrdersBySendDate,
      ),
      act: (cubit) => cubit.search('date'),
      expect: () => [
        LoadingState(),
        LoadedState(orders: tEmptyOrdersList),
      ],
    );

    blocTest<OrdersReportCubit, OrdersReportState>(
      'should emits [LoadingState, FailureState] when usecase return a failure'
      ' (not OrdersNotFound).',
      setUp: () {
        when(() => mockGetAllOrdersBySendDate(any()))
            .thenAnswer((_) async => Failure(tOrdersFailure));
      },
      build: () => OrdersReportCubit(
        mockGetAllOrdersBySendDate,
      ),
      act: (cubit) => cubit.search('date'),
      expect: () => [
        LoadingState(),
        FailureState(failure: tOrdersFailure),
      ],
    );
  });
}

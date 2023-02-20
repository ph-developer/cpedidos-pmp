import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_state.dart';

class MockSaveOrder extends Mock implements ISaveOrder {}

class MockDeleteOrder extends Mock implements IDeleteOrder {}

class MockGetOrderByTypeAndNumber extends Mock
    implements IGetOrderByTypeAndNumber {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

void main() {
  late ISaveOrder mockSaveOrder;
  late IDeleteOrder mockDeleteOrder;
  late IGetOrderByTypeAndNumber mockGetOrderByTypeAndNumber;

  setUp(() {
    mockSaveOrder = MockSaveOrder();
    mockDeleteOrder = MockDeleteOrder();
    mockGetOrderByTypeAndNumber = MockGetOrderByTypeAndNumber();
  });

  const tOrder = Order(number: 'number', type: 'type');
  final tOrdersFailure = MockOrdersFailure();

  group('reset', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterInitialState] when called.',
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [OrderRegisterInitialState()],
    );
  });

  group('setDirty', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterDirtyState] when called.',
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.setDirty(),
      expect: () => [OrderRegisterDirtyState()],
    );
  });

  group('search', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits nothing when called with type param empty.',
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.search('', 'number'),
      expect: () => [],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits nothing when called with number param empty.',
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.search('type', ''),
      expect: () => [],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterLoadingState, OrderRegisterLoadedSuccessState] when find order.',
      setUp: () {
        when(() => mockGetOrderByTypeAndNumber(any(), any()))
            .thenAnswer((_) async => const Success(tOrder));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.search('type', 'number'),
      expect: () => [
        OrderRegisterLoadingState(),
        OrderRegisterLoadedSuccessState(loadedOrder: tOrder),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterLoadingState, OrderRegisterLoadedEmptyState] when not find order.',
      setUp: () {
        when(() => mockGetOrderByTypeAndNumber(any(), any()))
            .thenAnswer((_) async => const Failure(OrderNotFound()));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.search('type', 'number'),
      expect: () => [
        OrderRegisterLoadingState(),
        OrderRegisterLoadedEmptyState(typeQuery: 'type', numberQuery: 'number'),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterLoadingState, OrderRegisterFailureState] when usecase return a failure.',
      setUp: () {
        when(() => mockGetOrderByTypeAndNumber(any(), any()))
            .thenAnswer((_) async => Failure(tOrdersFailure));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.search('type', 'number'),
      expect: () => [
        OrderRegisterLoadingState(),
        OrderRegisterFailureState(failure: tOrdersFailure),
      ],
    );
  });

  group('save', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterSavingState, OrderRegisterSavedState] when save order successfull.',
      setUp: () {
        when(() => mockSaveOrder(tOrder))
            .thenAnswer((_) async => const Success(tOrder));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.save(tOrder),
      expect: () => [
        OrderRegisterSavingState(),
        OrderRegisterSavedState(),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterSavingState, OrderRegisterFailureState] when usecase return a failure.',
      setUp: () {
        when(() => mockSaveOrder(tOrder))
            .thenAnswer((_) async => Failure(tOrdersFailure));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.save(tOrder),
      expect: () => [
        OrderRegisterSavingState(),
        OrderRegisterFailureState(failure: tOrdersFailure),
      ],
    );
  });

  group('delete', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterDeletingState, OrderRegisterDeletedState] when save order successfull.',
      setUp: () {
        when(() => mockDeleteOrder(tOrder))
            .thenAnswer((_) async => const Success(true));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.delete(tOrder),
      expect: () => [
        OrderRegisterDeletingState(),
        OrderRegisterDeletedState(),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [OrderRegisterDeletingState, OrderRegisterFailureState] when usecase return a failure.',
      setUp: () {
        when(() => mockDeleteOrder(tOrder))
            .thenAnswer((_) async => Failure(tOrdersFailure));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.delete(tOrder),
      expect: () => [
        OrderRegisterDeletingState(),
        OrderRegisterFailureState(failure: tOrdersFailure),
      ],
    );
  });
}

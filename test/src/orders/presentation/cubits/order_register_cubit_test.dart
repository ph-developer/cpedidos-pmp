import 'package:bloc_test/bloc_test.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

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

  const tOrder = Order(
    number: 'number',
    type: 'type',
    arrivalDate: 'arrivalDate',
    secretary: 'secretary',
    project: 'project',
    description: 'description',
  );
  final tOrdersFailure = MockOrdersFailure();

  group('reset', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [InitialState] when called.',
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [InitialState()],
    );
  });

  group('setDirty', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [DirtyState] when called.',
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.setDirty(),
      expect: () => [DirtyState()],
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
      'should emits [LoadingState, LoadedSuccessState] when find order.',
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
        LoadingState(),
        LoadedSuccessState(loadedOrder: tOrder),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [LoadingState, LoadedEmptyState] when not find order.',
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
        LoadingState(),
        LoadedEmptyState(typeQuery: 'type', numberQuery: 'number'),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [LoadingState, FailureState] when usecase returns failure.',
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
        LoadingState(),
        FailureState(failure: tOrdersFailure),
      ],
    );
  });

  group('save', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [SavingState, SavedState] when save order successfull.',
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
        SavingState(),
        SavedState(),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [SavingState, FailureState] when usecase return a failure.',
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
        SavingState(),
        FailureState(failure: tOrdersFailure),
      ],
    );
  });

  group('delete', () {
    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [DeletingState, DeletedState] when save order successfull.',
      setUp: () {
        when(() => mockDeleteOrder(tOrder.type, tOrder.number))
            .thenAnswer((_) async => const Success(unit));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.delete(tOrder),
      expect: () => [
        DeletingState(),
        DeletedState(),
      ],
    );

    blocTest<OrderRegisterCubit, OrderRegisterState>(
      'should emits [DeletingState, FailureState] when usecase return failure.',
      setUp: () {
        when(() => mockDeleteOrder(tOrder.type, tOrder.number))
            .thenAnswer((_) async => Failure(tOrdersFailure));
      },
      build: () => OrderRegisterCubit(
        mockSaveOrder,
        mockDeleteOrder,
        mockGetOrderByTypeAndNumber,
      ),
      act: (cubit) => cubit.delete(tOrder),
      expect: () => [
        DeletingState(),
        FailureState(failure: tOrdersFailure),
      ],
    );
  });
}

import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/orders/external/decorators/order_archive_datasource_decorator.dart';
import 'package:cpedidos_pmp/features/orders/infra/datasources/order_datasource.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late IOrderDatasource mockOrderDatasource;
  late FirebaseDatabase mockFirebaseDatabase;
  late DatabaseReference mockDatabaseReference;
  late DataSnapshot mockDataSnapshot;
  late OrderArchiveDatasourceDecorator decorator;

  setUp(() {
    mockOrderDatasource = MockOrderDatasource();
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();
    decorator = OrderArchiveDatasourceDecorator(
      mockOrderDatasource,
      mockFirebaseDatabase,
    );
  });

  const tType = 'type';
  const tNumber = 'number';
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
  const tArchivedOrder = Order(
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
    isArchived: true,
  );
  final tOrderMap = Map<String, dynamic>.from({
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
  });

  group('getOrderByTypeAndNumber', () {
    test(
      'should return decoratee getOrderByTypeAndNumber result if it not fail, '
      ' with isArchived false.',
      () async {
        // arrange
        when(() => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber))
            .thenAnswer((_) async => tOrder);
        // act
        final result = await decorator.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(result, equals(tOrder));
        expect(result.isArchived, isFalse);
        verify(
          () => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );

    test(
      'should search in archive when decoratee getOrderByTypeAndNumber throws '
      'an OrderNotFound failure, and return an Order with isArchived true if '
      'find.',
      () async {
        // arrange
        when(() => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber))
            .thenThrow(const OrderNotFound());
        when(() => mockFirebaseDatabase.ref(any()))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(true);
        when(() => mockDataSnapshot.value).thenReturn(tOrderMap);
        // act
        final result = await decorator.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(result, equals(tArchivedOrder));
        expect(result.isArchived, isTrue);
        verify(
          () => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );

    test(
      'should search in archive when decoratee getOrderByTypeAndNumber throws '
      'an OrderNotFound failure, and throws an OrderNotFound failure if not '
      'find.',
      () async {
        // arrange
        when(() => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber))
            .thenThrow(const OrderNotFound());
        when(() => mockFirebaseDatabase.ref(any()))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(false);
        // act
        final future = decorator.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(future, throwsA(isA<OrderNotFound>()));
        verify(
          () => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber),
        ).called(1);
        verifyNoMoreInteractions(mockOrderDatasource);
      },
    );

    test(
      'should rethrows an exception when decoratee throws an exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber))
            .thenThrow(tException);
        // act
        final future = decorator.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockOrderDatasource.getOrderByTypeAndNumber(tType, tNumber))
            .thenThrow(const OrderNotFound());
        when(() => mockFirebaseDatabase.ref(any())).thenThrow(tException);
        // act
        final future = decorator.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });
}

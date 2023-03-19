import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:cpedidos_pmp/features/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/features/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/orders/external/datasources/order_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late FirebaseFirestore mockFirebaseFirestore;
  late CollectionReference<Map<String, dynamic>> mockCollectionReference;
  late DocumentReference<Map<String, dynamic>> mockDocumentReference;
  late DocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late Query<Map<String, dynamic>> mockQuery;
  late QuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late QueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
  late OrderDatasourceImpl datasource;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    datasource = OrderDatasourceImpl(mockFirebaseFirestore);
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
  const tOrderList = [tOrder];
  const tOrderEmptyList = <Order>[];

  group('getOrderByTypeAndNumber', () {
    test(
      'should return an order when find order.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc('${tType}_$tNumber'))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get)
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(true);
        when(() => mockDocumentSnapshot.data()).thenReturn(tOrderMap);
        // act
        final result = await datasource.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(result, equals(tOrder));
      },
    );

    test(
      'should throws an OrderNotFound failure when not find order.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc('${tType}_$tNumber'))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get)
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.exists).thenReturn(false);
        // act
        final future = datasource.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(future, throwsA(isA<OrderNotFound>()));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenThrow(tException);
        // act
        final future = datasource.getOrderByTypeAndNumber(tType, tNumber);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('getAllOrdersBySendDate', () {
    test(
      'should return a filled list when orders with sendDate param exists.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(
          () => mockCollectionReference.where('sendDate', isEqualTo: tSendDate),
        ).thenReturn(mockQuery);
        when(mockQuery.get).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs)
            .thenReturn([mockQueryDocumentSnapshot]);
        when(() => mockQueryDocumentSnapshot.data()).thenReturn(tOrderMap);
        // act
        final result = await datasource.getAllOrdersBySendDate(tSendDate);
        // assert
        expect(result, equals(tOrderList));
      },
    );

    test(
      'should return an empty list when orders with sendDate param not exists.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(
          () => mockCollectionReference.where('sendDate', isEqualTo: tSendDate),
        ).thenReturn(mockQuery);
        when(mockQuery.get).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs).thenReturn([]);
        // act
        final result = await datasource.getAllOrdersBySendDate(tSendDate);
        // assert
        expect(result, equals(tOrderEmptyList));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenThrow(tException);
        // act
        final future = datasource.getAllOrdersBySendDate(tSendDate);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('getAllOrdersByArrivalDate', () {
    test(
      'should return a filled list when orders with sendDate param exists.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(
          () => mockCollectionReference.where(
            'arrivalDate',
            isEqualTo: tArrivalDate,
          ),
        ).thenReturn(mockQuery);
        when(mockQuery.get).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs)
            .thenReturn([mockQueryDocumentSnapshot]);
        when(() => mockQueryDocumentSnapshot.data()).thenReturn(tOrderMap);
        // act
        final result = await datasource.getAllOrdersByArrivalDate(tArrivalDate);
        // assert
        expect(result, equals(tOrderList));
      },
    );

    test(
      'should return an empty list when orders with sendDate param not exists.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(
          () => mockCollectionReference.where(
            'arrivalDate',
            isEqualTo: tArrivalDate,
          ),
        ).thenReturn(mockQuery);
        when(mockQuery.get).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs).thenReturn([]);
        // act
        final result = await datasource.getAllOrdersByArrivalDate(tArrivalDate);
        // assert
        expect(result, equals(tOrderEmptyList));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenThrow(tException);
        // act
        final future = datasource.getAllOrdersByArrivalDate(tArrivalDate);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('saveOrder', () {
    test(
      'should return an order when save order.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc('${tType}_$tNumber'))
            .thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(tOrderMap))
            .thenAnswer((_) async {});
        // act
        final result = await datasource.saveOrder(tOrder);
        // assert
        expect(result, equals(tOrder));
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenThrow(tException);
        // act
        final future = datasource.saveOrder(tOrder);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });

  group('deleteOrder', () {
    test(
      'should return true when delete order.',
      () async {
        // arrange
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc('${tType}_$tNumber'))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.delete).thenAnswer((_) async {});
        // act
        final result = await datasource.deleteOrder(tOrder);
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should rethrows an exception when occurs an unknown exception.',
      () async {
        // arrange
        final tException = Exception();
        when(() => mockFirebaseFirestore.collection('orders'))
            .thenThrow(tException);
        // act
        final future = datasource.deleteOrder(tOrder);
        // assert
        expect(future, throwsA(equals(tException)));
      },
    );
  });
}

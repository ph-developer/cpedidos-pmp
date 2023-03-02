// import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
// import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
// import 'package:cpedidos_pmp/src/orders/external/datasources/order_datasource_impl.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../mocks.dart';

void main() {
//   late FirebaseDatabase mockFirebaseDatabase;
//   late DatabaseReference mockDatabaseReference;
//   late DataSnapshot mockDataSnapshot;
//   late OrderDatasourceImpl datasource;

//   setUp(() {
//     mockFirebaseDatabase = MockFirebaseDatabase();
//     mockDatabaseReference = MockDatabaseReference();
//     mockDataSnapshot = MockDataSnapshot();
//     datasource = OrderDatasourceImpl(mockFirebaseDatabase);
//   });

//   const tType = 'type';
//   const tNumber = 'number';
//   const tSendDate = 'sendDate';
//   const tOrder = Order(
//     number: tNumber,
//     type: tType,
//     arrivalDate: 'arrivalDate',
//     secretary: 'secretary',
//     project: 'project',
//     description: 'description',
//     sendDate: 'sendDate',
//     returnDate: 'returnDate',
//     situation: 'situation',
//     notes: 'notes',
//   );
//   final tOrderMap = Map<String, dynamic>.from({
//     'number': tNumber,
//     'type': tType,
//     'arrivalDate': 'arrivalDate',
//     'secretary': 'secretary',
//     'project': 'project',
//     'description': 'description',
//     'sendDate': 'sendDate',
//     'returnDate': 'returnDate',
//     'situation': 'situation',
//     'notes': 'notes',
//   });
//   final tOrdersMap = Map<String, dynamic>.from({
//     '${tType}_$tNumber': tOrderMap,
//   });
//   const tOrderList = [tOrder];
//   final tOrdersEmptyMap = Map<String, dynamic>.from({});
//   const tOrderEmptyList = <Order>[];

//   group('getOrderByTypeAndNumber', () {
//     test(
//       'should return an order when find order.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.get())
//             .thenAnswer((_) async => mockDataSnapshot);
//         when(() => mockDataSnapshot.exists).thenReturn(true);
//         when(() => mockDataSnapshot.value).thenReturn(tOrderMap);
//         // act
//      final result = await datasource.getOrderByTypeAndNumber(tType, tNumber);
//         // assert
//         expect(result, equals(tOrder));
//       },
//     );

//     test(
//       'should throws an OrderNotFound failure when not find order.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.get())
//             .thenAnswer((_) async => mockDataSnapshot);
//         when(() => mockDataSnapshot.exists).thenReturn(false);
//         // act
//         final future = datasource.getOrderByTypeAndNumber(tType, tNumber);
//         // assert
//         expect(future, throwsA(isA<OrderNotFound>()));
//       },
//     );

//     test(
//       'should rethrows an exception when occurs an unknown exception.',
//       () async {
//         // arrange
//         final tException = Exception();
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenThrow(tException);
//         // act
//         final future = datasource.getOrderByTypeAndNumber(tType, tNumber);
//         // assert
//         expect(future, throwsA(equals(tException)));
//       },
//     );
//   });

//   group('getAllOrdersBySendDate', () {
//     test(
//       'should return a filled list when orders with sendDate param exists.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.orderByChild('sendDate'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.equalTo(tSendDate))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.get())
//             .thenAnswer((_) async => mockDataSnapshot);
//         when(() => mockDataSnapshot.exists).thenReturn(true);
//         when(() => mockDataSnapshot.value).thenReturn(tOrdersMap);
//         // act
//         final result = await datasource.getAllOrdersBySendDate(tSendDate);
//         // assert
//         expect(result, equals(tOrderList));
//       },
//     );

//     test(
//    'should return an empty list when orders with sendDate param not exists.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.orderByChild('sendDate'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.equalTo(tSendDate))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.get())
//             .thenAnswer((_) async => mockDataSnapshot);
//         when(() => mockDataSnapshot.exists).thenReturn(true);
//         when(() => mockDataSnapshot.value).thenReturn(tOrdersEmptyMap);
//         // act
//         final result = await datasource.getAllOrdersBySendDate(tSendDate);
//         // assert
//         expect(result, equals(tOrderEmptyList));
//       },
//     );

//     test(
//       'should throws an OrdersNotFound failure when snapshot not exists.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.orderByChild('sendDate'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.equalTo(tSendDate))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.get())
//             .thenAnswer((_) async => mockDataSnapshot);
//         when(() => mockDataSnapshot.exists).thenReturn(false);
//         // act
//         final future = datasource.getAllOrdersBySendDate(tSendDate);
//         // assert
//         expect(future, throwsA(isA<OrdersNotFound>()));
//       },
//     );

//     test(
//       'should rethrows an exception when occurs an unknown exception.',
//       () async {
//         // arrange
//         final tException = Exception();
//         when(() => mockFirebaseDatabase.ref('orders')).thenThrow(tException);
//         // act
//         final future = datasource.getAllOrdersBySendDate(tSendDate);
//         // assert
//         expect(future, throwsA(equals(tException)));
//       },
//     );
//   });

//   group('saveOrder', () {
//     test(
//       'should return an order when save order.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.set(tOrderMap))
//             .thenAnswer((_) async {});
//         // act
//         final result = await datasource.saveOrder(tOrder);
//         // assert
//         expect(result, equals(tOrder));
//       },
//     );

//     test(
//       'should rethrows an exception when occurs an unknown exception.',
//       () async {
//         // arrange
//         final tException = Exception();
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenThrow(tException);
//         // act
//         final future = datasource.saveOrder(tOrder);
//         // assert
//         expect(future, throwsA(equals(tException)));
//       },
//     );
//   });

//   group('deleteOrder', () {
//     test(
//       'should return true when delete order.',
//       () async {
//         // arrange
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenReturn(mockDatabaseReference);
//         when(() => mockDatabaseReference.remove()).thenAnswer((_) async {});
//         // act
//         final result = await datasource.deleteOrder(tType, tNumber);
//         // assert
//         expect(result, isTrue);
//       },
//     );

//     test(
//       'should rethrows an exception when occurs an unknown exception.',
//       () async {
//         // arrange
//         final tException = Exception();
//         when(() => mockFirebaseDatabase.ref('orders/${tType}_$tNumber'))
//             .thenThrow(tException);
//         // act
//         final future = datasource.deleteOrder(tType, tNumber);
//         // assert
//         expect(future, throwsA(equals(tException)));
//       },
//     );
//   });
}

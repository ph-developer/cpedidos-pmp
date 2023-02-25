import 'package:cpedidos_pmp/src/orders/data/repositories/remote/firebase_order_remote_repo.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late FirebaseDatabase mockDatabase;
  late DatabaseReference mockDatabaseReference;
  late DataSnapshot mockDataSnapshot;
  late FirebaseOrderRemoteRepo repo;

  setUp(() {
    mockDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();
    repo = FirebaseOrderRemoteRepo(mockDatabase);
  });

  group('getByTypeAndNumber', () {
    const tOrder = Order(
      number: 'number',
      type: 'type',
      arrivalDate: 'arrivalDate',
      secretary: 'secretary',
      project: 'project',
      description: 'description',
    );
    const tOrderMap = {
      'number': 'number',
      'type': 'type',
      'arrivalDate': 'arrivalDate',
      'secretary': 'secretary',
      'project': 'project',
      'description': 'description',
    };

    test(
      'should return an order entity when exists one with type and number param.',
      () async {
        // arrange
        when(() => mockDatabase.ref('orders/type_number'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(true);
        when(() => mockDataSnapshot.value).thenReturn(tOrderMap);
        // act
        final result = await repo.getByTypeAndNumber('type', 'number');
        // assert
        expect(result.getOrNull(), equals(tOrder));
      },
    );

    test(
      'should return an OrderNotFound failure when not exists one with type and number param.',
      () async {
        // arrange
        when(() => mockDatabase.ref('orders/not_exists'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(false);
        // act
        final result = await repo.getByTypeAndNumber('not', 'exists');
        // assert
        expect(result.exceptionOrNull(), isA<OrderNotFound>());
      },
    );
  });

  group('getAllBySendDate', () {
    const tOrderList = [
      Order(
        number: 'number',
        type: 'type',
        sendDate: 'sendDate',
        arrivalDate: 'arrivalDate',
        secretary: 'secretary',
        project: 'project',
        description: 'description',
      ),
    ];
    const tOrderMap = {
      'number': 'number',
      'type': 'type',
      'sendDate': 'sendDate',
      'arrivalDate': 'arrivalDate',
      'secretary': 'secretary',
      'project': 'project',
      'description': 'description',
    };
    const tOrderListMap = {'type_number': tOrderMap};

    test(
      'should return a filled list when orders with sendDate param exists.',
      () async {
        // arrange
        when(() => mockDatabase.ref('orders'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.orderByChild('sendDate'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.equalTo('sendDate'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(true);
        when(() => mockDataSnapshot.value).thenReturn(tOrderListMap);
        // act
        final result = await repo.getAllBySendDate('sendDate');
        // assert
        expect(result.getOrNull(), equals(tOrderList));
      },
    );

    test(
      'should return an empty list when orders with sendDate param not exists.',
      () async {
        // arrange
        when(() => mockDatabase.ref('orders'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.orderByChild('sendDate'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.equalTo('notExists'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(true);
        when(() => mockDataSnapshot.value)
            .thenReturn(Map<String, dynamic>.from({}));
        // act
        final result = await repo.getAllBySendDate('notExists');
        // assert
        expect(result.getOrNull(), isA<List<Order>>());
        expect(result.getOrNull(), isEmpty);
      },
    );

    test(
      'should return an OrdersNotFound failure when orders snapshot with sendDate param not exists.',
      () async {
        // arrange
        when(() => mockDatabase.ref('orders'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.orderByChild('sendDate'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.equalTo('notExists'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.get())
            .thenAnswer((_) async => mockDataSnapshot);
        when(() => mockDataSnapshot.exists).thenReturn(false);
        // act
        final result = await repo.getAllBySendDate('notExists');
        // assert
        expect(result.exceptionOrNull(), isA<OrdersNotFound>());
      },
    );
  });

  group('save', () {
    const tOrder = Order(
      number: 'number',
      type: 'type',
      notes: 'notes',
      arrivalDate: 'arrivalDate',
      secretary: 'secretary',
      project: 'project',
      description: 'description',
    );
    const tOrderMap = {
      'number': 'number',
      'type': 'type',
      'arrivalDate': 'arrivalDate',
      'secretary': 'secretary',
      'project': 'project',
      'description': 'description',
      'sendDate': '',
      'returnDate': '',
      'situation': '',
      'notes': 'notes',
    };

    test(
      'should save an order entity into db and return the entity.',
      () async {
        // act
        when(() => mockDatabase.ref('orders/type_number'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.set(tOrderMap))
            .thenAnswer((_) async {});

        final result = await repo.save(tOrder);
        // assert
        expect(result.getOrNull(), equals(tOrder));
      },
    );
  });

  group('delete', () {
    const tOrder = Order(
      number: 'number',
      type: 'type',
      notes: 'notes',
      arrivalDate: 'arrivalDate',
      secretary: 'secretary',
      project: 'project',
      description: 'description',
    );

    test(
      'should delete an order entity and return true.',
      () async {
        // act
        when(() => mockDatabase.ref('orders/type_number'))
            .thenReturn(mockDatabaseReference);
        when(() => mockDatabaseReference.remove()).thenAnswer((_) async {});

        final result = await repo.delete(tOrder);
        // assert
        expect(result.getOrNull(), isTrue);
      },
    );
  });
}

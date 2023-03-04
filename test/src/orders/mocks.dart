// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpedidos_pmp/src/auth/presentation/cubits/auth_cubit.dart';
import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/src/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/src/orders/infra/datasources/order_datasource.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/order_register_cubit.dart';
import 'package:cpedidos_pmp/src/orders/presentation/cubits/orders_search_cubit.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:mocktail/mocktail.dart';

class MockOrdersFailure extends Mock implements OrdersFailure {}

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockOrderDatasource extends Mock implements IOrderDatasource {}

class MockErrorService extends Mock implements IErrorService {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

class MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

class MockDocumentSnapshot<T> extends Mock implements DocumentSnapshot<T> {}

class MockQuery<T> extends Mock implements Query<T> {}

class MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

class MockOrdersSearchCubit extends Mock implements OrdersSearchCubit {}

class MockAuthCubit extends Mock implements AuthCubit {}

class MockOrderRegisterCubit extends Mock implements OrderRegisterCubit {}

class MockGetAllOrdersBySendDate extends Mock
    implements IGetAllOrdersBySendDate {}

class MockGetAllOrdersByArrivalDate extends Mock
    implements IGetAllOrdersByArrivalDate {}

class MockSaveOrder extends Mock implements ISaveOrder {}

class MockDeleteOrder extends Mock implements IDeleteOrder {}

class MockGetOrderByTypeAndNumber extends Mock
    implements IGetOrderByTypeAndNumber {}

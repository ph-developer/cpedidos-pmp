import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/infra/datasources/order_datasource.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersFailure extends Mock implements OrdersFailure {}

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockOrderDatasource extends Mock implements IOrderDatasource {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

class MockErrorService extends Mock implements IErrorService {}

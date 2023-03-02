import 'package:cpedidos_pmp/src/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/src/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/src/orders/infra/datasources/order_datasource.dart';
import 'package:cpedidos_pmp/src/shared/services/error_service.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersFailure extends Mock implements OrdersFailure {}

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockOrderDatasource extends Mock implements IOrderDatasource {}

class MockErrorService extends Mock implements IErrorService {}

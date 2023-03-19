// ignore_for_file: subtype_of_sealed_class

import 'package:auto_injector/auto_injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpedidos_pmp/core/errors/error_handler.dart';
import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:cpedidos_pmp/features/auth/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/auth/domain/repositories/auth_repository.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_login.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/do_logout.dart';
import 'package:cpedidos_pmp/features/auth/domain/usecases/get_current_user.dart';
import 'package:cpedidos_pmp/features/auth/infra/datasources/auth_datasource.dart';
import 'package:cpedidos_pmp/features/auth/presentation/stores/auth_store.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/domain/repositories/material_catalog_repository.dart';
import 'package:cpedidos_pmp/features/catalog/domain/repositories/service_catalog_repository.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_material_by_code.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_group_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_service_by_code.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_group_description.dart';
import 'package:cpedidos_pmp/features/catalog/infra/datasources/material_catalog_datasource.dart';
import 'package:cpedidos_pmp/features/catalog/infra/datasources/service_catalog_datasource.dart';
import 'package:cpedidos_pmp/features/catalog/presentation/controllers/items_search_controller.dart';
import 'package:cpedidos_pmp/features/orders/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/orders/domain/repositories/order_repository.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/delete_order.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/get_order_by_type_and_number.dart';
import 'package:cpedidos_pmp/features/orders/domain/usecases/save_order.dart';
import 'package:cpedidos_pmp/features/orders/infra/datasources/order_datasource.dart';
import 'package:cpedidos_pmp/features/orders/presentation/controllers/order_register_controller.dart';
import 'package:cpedidos_pmp/features/orders/presentation/controllers/orders_search_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MockSentryClient extends Mock implements SentryClient {}

abstract class Callable<T, U, V> {
  void call([T? p0, U? p1, V? p2]) {}
}

class MockCallable<T, U, V> extends Mock implements Callable<T, U, V> {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockFirebasePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockFirebaseAppPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseAppPlatform {}

class MockFirebaseAuthPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseAuthPlatform {}

class MockAuthStore extends Mock implements AuthStore {}

class MockBuildContext extends Mock implements BuildContext {}

class MockGoRouterState extends Mock implements GoRouterState {}

class MockAuthFailure extends Mock implements AuthFailure {}

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthDatasource extends Mock implements IAuthDatasource {}

class MockErrorHandler extends Mock implements IErrorHandler {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockGetCurrentUser extends Mock implements IGetCurrentUser {}

class MockDoLogin extends Mock implements IDoLogin {}

class MockDoLogout extends Mock implements IDoLogout {}

class MockOrdersSearchController extends Mock
    implements OrdersSearchController {}

class MockOrderRegisterController extends Mock
    implements OrderRegisterController {}

class MockGoRouter extends Mock implements GoRouter {}

class MockItemsSearchController extends Mock implements ItemsSearchController {}

class MockMaterialCatalogDatasource extends Mock
    implements IMaterialCatalogDatasource {}

class MockServiceCatalogDatasource extends Mock
    implements IServiceCatalogDatasource {}

class MockMaterialCatalogRepository extends Mock
    implements IMaterialCatalogRepository {}

class MockServiceCatalogRepository extends Mock
    implements IServiceCatalogRepository {}

class MockCatalogFailure extends Mock implements CatalogFailure {}

class MockGetMaterialByCode extends Mock implements IGetMaterialByCode {}

class MockGetMaterialsByDescription extends Mock
    implements IGetMaterialsByDescription {}

class MockGetMaterialsByGroupDescription extends Mock
    implements IGetMaterialsByGroupDescription {}

class MockGetServiceByCode extends Mock implements IGetServiceByCode {}

class MockGetServicesByDescription extends Mock
    implements IGetServicesByDescription {}

class MockGetServicesByGroupDescription extends Mock
    implements IGetServicesByGroupDescription {}

class MockOrdersFailure extends Mock implements OrdersFailure {}

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockOrderDatasource extends Mock implements IOrderDatasource {}

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

class MockGetAllOrdersBySendDate extends Mock
    implements IGetAllOrdersBySendDate {}

class MockGetAllOrdersByArrivalDate extends Mock
    implements IGetAllOrdersByArrivalDate {}

class MockSaveOrder extends Mock implements ISaveOrder {}

class MockDeleteOrder extends Mock implements IDeleteOrder {}

class MockGetOrderByTypeAndNumber extends Mock
    implements IGetOrderByTypeAndNumber {}

class MockSnackbarHelper extends Mock implements SnackbarHelper {}

class MockAutoInjector extends Mock implements AutoInjector {}

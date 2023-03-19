import 'package:auto_injector/auto_injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/do_login.dart';
import '../../features/auth/domain/usecases/do_logout.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/external/datasources/auth_datasource_impl.dart';
import '../../features/auth/infra/datasources/auth_datasource.dart';
import '../../features/auth/infra/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/stores/auth_store.dart';
import '../../features/catalog/domain/repositories/material_catalog_repository.dart';
import '../../features/catalog/domain/repositories/service_catalog_repository.dart';
import '../../features/catalog/domain/usecases/get_material_by_code.dart';
import '../../features/catalog/domain/usecases/get_materials_by_description.dart';
import '../../features/catalog/domain/usecases/get_materials_by_group_description.dart';
import '../../features/catalog/domain/usecases/get_service_by_code.dart';
import '../../features/catalog/domain/usecases/get_services_by_description.dart';
import '../../features/catalog/domain/usecases/get_services_by_group_description.dart';
import '../../features/catalog/external/datasources/material_catalog_datasource_impl.dart';
import '../../features/catalog/external/datasources/service_catalog_datasource_impl.dart';
import '../../features/catalog/infra/datasources/material_catalog_datasource.dart';
import '../../features/catalog/infra/datasources/service_catalog_datasource.dart';
import '../../features/catalog/infra/repositories/material_catalog_repository_impl.dart';
import '../../features/catalog/infra/repositories/service_catalog_repository_impl.dart';
import '../../features/catalog/presentation/controllers/items_search_controller.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/delete_order.dart';
import '../../features/orders/domain/usecases/get_all_orders_by_arrival_date.dart';
import '../../features/orders/domain/usecases/get_all_orders_by_send_date.dart';
import '../../features/orders/domain/usecases/get_order_by_type_and_number.dart';
import '../../features/orders/domain/usecases/save_order.dart';
import '../../features/orders/external/datasources/order_datasource_impl.dart';
import '../../features/orders/external/decorators/order_archive_datasource_decorator.dart';
import '../../features/orders/infra/datasources/order_datasource.dart';
import '../../features/orders/infra/repositories/order_repository_impl.dart';
import '../../features/orders/presentation/controllers/order_register_controller.dart';
import '../../features/orders/presentation/controllers/orders_search_controller.dart';
import '../errors/error_handler.dart';
import '../errors/error_handler_impl.dart';

typedef Injector = AutoInjector;
typedef InjectFn = Future<void> Function(Injector injector);

AutoInjector _injector = AutoInjector();
T inject<T>() => _injector<T>();

@visibleForTesting
void setInjector(AutoInjector injector) {
  _injector = injector;
}

Future<void> setupInjector([InjectFn? injectFn]) async {
  if (injectFn != null) return injectFn(_injector);

  await _injectCore(_injector);
  await _injectAuthFeature(_injector);
  await _injectCatalogFeature(_injector);
  await _injectOrdersFeature(_injector);

  _injector.commit();
}

Future<void> _injectCore(Injector injector) async {
  injector
    //! Firebase
    ..addSingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..addSingleton<FirebaseDatabase>(() => FirebaseDatabase.instance)
    ..addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)

    //! Core
    ..add<IErrorHandler>(ErrorHandlerImpl.new);
}

Future<void> _injectAuthFeature(Injector injector) async {
  injector
    //! Datasources
    ..add<IAuthDatasource>(AuthDatasourceImpl.new)

    //! Repositories
    ..add<IAuthRepository>(AuthRepositoryImpl.new)

    //! Usecases
    ..add<IDoLogin>(DoLoginImpl.new)
    ..add<IDoLogout>(DoLogoutImpl.new)
    ..add<IGetCurrentUser>(GetCurrentUserImpl.new)

    //! Stores
    ..addSingleton<AuthStore>(AuthStore.new);
}

Future<void> _injectCatalogFeature(Injector injector) async {
  injector
    //! Datasources
    ..add<IMaterialCatalogDatasource>(MaterialCatalogDatasourceImpl.new)
    ..add<IServiceCatalogDatasource>(ServiceCatalogDatasourceImpl.new)

    //! Repositories
    ..add<IMaterialCatalogRepository>(MaterialCatalogRepositoryImpl.new)
    ..add<IServiceCatalogRepository>(ServiceCatalogRepositoryImpl.new)

    //! Usecases
    ..add<IGetMaterialByCode>(GetMaterialByCodeImpl.new)
    ..add<IGetMaterialsByDescription>(GetMaterialsByDescriptionImpl.new)
    ..add<IGetMaterialsByGroupDescription>(
      GetMaterialsByGroupDescriptionImpl.new,
    )
    ..add<IGetServiceByCode>(GetServiceByCodeImpl.new)
    ..add<IGetServicesByDescription>(GetServicesByDescriptionImpl.new)
    ..add<IGetServicesByGroupDescription>(GetServicesByGroupDescriptionImpl.new)

    //! Controllers
    ..add<ItemsSearchController>(ItemsSearchController.new);
}

Future<void> _injectOrdersFeature(Injector injector) async {
  final i = injector;

  injector
    //! Datasources
    ..add<IOrderDatasource>(
      () => OrderArchiveDatasourceDecorator(OrderDatasourceImpl(i()), i()),
    )

    //! Respositories
    ..add<IOrderRepository>(OrderRepositoryImpl.new)

    //! Usecases
    ..add<IDeleteOrder>(DeleteOrderImpl.new)
    ..add<IGetAllOrdersByArrivalDate>(GetAllOrdersByArrivalDateImpl.new)
    ..add<IGetAllOrdersBySendDate>(GetAllOrdersBySendDateImpl.new)
    ..add<IGetOrderByTypeAndNumber>(GetOrderByTypeAndNumberImpl.new)
    ..add<ISaveOrder>(SaveOrderImpl.new)

    //! Controllers
    ..add<OrdersSearchController>(OrdersSearchController.new)
    ..add<OrderRegisterController>(OrderRegisterController.new);
}

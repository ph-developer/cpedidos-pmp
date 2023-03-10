// coverage:ignore-file

import 'package:flutter_modular/flutter_modular.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/usecases/delete_order.dart';
import 'domain/usecases/get_all_orders_by_arrival_date.dart';
import 'domain/usecases/get_all_orders_by_send_date.dart';
import 'domain/usecases/get_order_by_type_and_number.dart';
import 'domain/usecases/save_order.dart';
import 'external/datasources/order_datasource_impl.dart';
import 'external/decorators/order_archive_datasource_decorator.dart';
import 'infra/datasources/order_datasource.dart';
import 'infra/repositories/order_repository_impl.dart';
import 'presentation/cubits/order_register_cubit.dart';
import 'presentation/cubits/orders_search_cubit.dart';
import 'presentation/pages/order_register_page.dart';
import 'presentation/pages/orders_search_page.dart';

class OrdersModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/cadastro', child: (_, __) => const OrderRegisterPage()),
        ChildRoute('/busca', child: (_, __) => const OrdersSearchPage()),
        RedirectRoute('/', to: '/cadastro'),
      ];

  @override
  List<Bind> get binds => [
        //! External
        Bind.factory<IOrderDatasource>(
          (i) => OrderArchiveDatasourceDecorator(
            OrderDatasourceImpl(i()),
            i(),
          ),
          export: true,
        ),

        //! Infra
        Bind.factory<IOrderRepository>(
          (i) => OrderRepositoryImpl(i(), i()),
          export: true,
        ),

        //! Domain
        Bind.factory<IDeleteOrder>(
          (i) => DeleteOrder(i()),
          export: true,
        ),
        Bind.factory<IGetAllOrdersBySendDate>(
          (i) => GetAllOrdersBySendDate(i()),
          export: true,
        ),
        Bind.factory<IGetAllOrdersByArrivalDate>(
          (i) => GetAllOrdersByArrivalDate(i()),
          export: true,
        ),
        Bind.factory<IGetOrderByTypeAndNumber>(
          (i) => GetOrderByTypeAndNumber(i()),
          export: true,
        ),
        Bind.factory<ISaveOrder>(
          (i) => SaveOrder(i()),
          export: true,
        ),

        //! Presentation
        Bind.factory<OrderRegisterCubit>(
          (i) => OrderRegisterCubit(i(), i(), i()),
          export: true,
        ),
        Bind.factory<OrdersSearchCubit>(
          (i) => OrdersSearchCubit(i(), i()),
          export: true,
        ),
      ];
}

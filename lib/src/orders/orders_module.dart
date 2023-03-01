// coverage:ignore-file

import 'package:flutter_modular/flutter_modular.dart';
import '../auth/presentation/guards/auth_guard.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/services/report_service.dart';
import 'domain/usecases/delete_order.dart';
import 'domain/usecases/get_all_orders_by_send_date.dart';
import 'domain/usecases/get_order_by_type_and_number.dart';
import 'domain/usecases/print_orders_report.dart';
import 'domain/usecases/save_order.dart';
import 'external/datasources/order_datasource_impl.dart';
import 'external/drivers/printer_driver_impl.dart';
import 'infra/datasources/order_datasource.dart';
import 'infra/drivers/printer_driver.dart';
import 'infra/repositories/order_repository_impl.dart';
import 'infra/services/report_service_impl.dart';
import 'presentation/cubits/order_register_cubit.dart';
import 'presentation/cubits/orders_report_cubit.dart';
import 'presentation/pages/order_register_page.dart';
// import 'presentation/pages/orders_report_page.dart';

class OrdersModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/cadastro',
          child: (_, __) => const OrderRegisterPage(),
          guards: [AuthGuard()],
        ),
        // ChildRoute(
        //   '/relatorio',
        //   child: (_, __) => const OrdersReportPage(),
        //   guards: [AuthGuard()],
        // ),
        RedirectRoute('/', to: '/cadastro'),
      ];

  @override
  List<Bind> get binds => [
        //! External
        Bind.factory<IOrderDatasource>(
          (i) => OrderDatasourceImpl(i()),
          export: true,
        ),
        Bind.factory<IPrinterDriver>(
          (i) => PrinterDriverImpl(),
          export: true,
        ),

        //! Infra
        Bind.factory<IOrderRepository>(
          (i) => OrderRepositoryImpl(i(), i()),
          export: true,
        ),
        Bind.factory<IReportService>(
          (i) => ReportServiceImpl(i(), i()),
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
        Bind.factory<IGetOrderByTypeAndNumber>(
          (i) => GetOrderByTypeAndNumber(i()),
          export: true,
        ),
        Bind.factory<ISaveOrder>(
          (i) => SaveOrder(i()),
          export: true,
        ),
        Bind.factory<IPrintOrdersReport>(
          (i) => PrintOrdersReport(i()),
          export: true,
        ),

        //! Presentation
        Bind.factory<OrderRegisterCubit>(
          (i) => OrderRegisterCubit(i(), i(), i()),
          export: true,
        ),
        Bind.factory<OrdersReportCubit>(
          (i) => OrdersReportCubit(i(), i()),
          export: true,
        ),
      ];
}

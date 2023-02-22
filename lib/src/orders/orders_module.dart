import 'package:flutter_modular/flutter_modular.dart';

import '../auth/presentation/guards/auth_guard.dart';

import 'data/repositories/remote/firebase_order_remote_repo.dart';
import 'data/services/pdf_service.dart';
import 'data/services/print_service.dart';
import 'domain/repositories/order_repo.dart';
import 'domain/services/pdf_service.dart';
import 'domain/services/print_service.dart';
import 'domain/usecases/delete_order.dart';
import 'domain/usecases/get_all_orders_by_send_date.dart';
import 'domain/usecases/get_order_by_type_and_number.dart';
import 'domain/usecases/print_orders_report.dart';
import 'domain/usecases/save_order.dart';
import 'presentation/cubits/order_register_cubit.dart';
import 'presentation/cubits/orders_report_cubit.dart';
import 'presentation/pages/order_register_page.dart';
import 'presentation/pages/orders_report_page.dart';

class OrdersModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/cadastro',
          child: (_, __) => const OrderRegisterPage(),
          guards: [AuthGuard()],
        ),
        ChildRoute(
          '/relatorio',
          child: (_, __) => const OrdersReportPage(),
          guards: [AuthGuard()],
        ),
        RedirectRoute('/', to: '/cadastro'),
      ];

  @override
  List<Bind> get binds => [
        Bind.factory<IOrderRepo>(
          (i) => FirebaseOrderRemoteRepo(i()),
          export: true,
        ),
        Bind.factory<IPdfService>(
          (i) => PdfService(),
          export: true,
        ),
        Bind.factory<IPrintService>(
          (i) => PrintService(),
          export: true,
        ),
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
          (i) => PrintOrdersReport(i(), i()),
          export: true,
        ),
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

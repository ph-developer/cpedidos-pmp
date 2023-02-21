import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth/data/repositories/remote/firebase_auth_remote_repo.dart';
import 'auth/data/repositories/remote/firebase_user_remote_repo.dart';
import 'auth/domain/repositories/auth_repo.dart';
import 'auth/domain/repositories/user_repo.dart';
import 'auth/domain/usecases/do_login.dart';
import 'auth/domain/usecases/do_logout.dart';
import 'auth/domain/usecases/get_current_user.dart';
import 'auth/presentation/cubits/auth_cubit.dart';
import 'auth/presentation/guards/auth_guard.dart';
import 'auth/presentation/guards/guest_guard.dart';
import 'auth/presentation/pages/login_page.dart';
import 'orders/data/repositories/remote/firebase_order_remote_repo.dart';
import 'orders/data/services/pdf_service.dart';
import 'orders/data/services/print_service.dart';
import 'orders/domain/repositories/order_repo.dart';
import 'orders/domain/services/pdf_service.dart';
import 'orders/domain/services/print_service.dart';
import 'orders/domain/usecases/delete_order.dart';
import 'orders/domain/usecases/get_all_orders_by_send_date.dart';
import 'orders/domain/usecases/get_order_by_type_and_number.dart';
import 'orders/domain/usecases/print_orders_report.dart';
import 'orders/domain/usecases/save_order.dart';
import 'orders/presentation/cubits/order_register_cubit.dart';
import 'orders/presentation/cubits/orders_report_cubit.dart';
import 'orders/presentation/pages/order_register_page.dart';
import 'orders/presentation/pages/orders_report_page.dart';
import 'shared/config/theme/theme_config.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/login',
          child: (_, __) => const LoginPage(),
          guards: [GuestGuard()],
        ),
        ChildRoute(
          '/pedidos/cadastro',
          child: (_, __) => const OrderRegisterPage(),
          guards: [AuthGuard()],
        ),
        ChildRoute(
          '/pedidos/relatorio',
          child: (_, __) => const OrdersReportPage(),
          guards: [AuthGuard()],
        ),
        RedirectRoute('/', to: '/login'),
      ];

  @override
  List<Bind> get binds => [
        Bind.factory<FirebaseAuth>(
          (i) => FirebaseAuth.instance,
        ),
        Bind.factory<FirebaseDatabase>(
          (i) => FirebaseDatabase.instance,
        ),
        Bind.factory<IAuthRepo>(
          (i) => FirebaseAuthRemoteRepo(i()),
        ),
        Bind.factory<IUserRepo>(
          (i) => FirebaseUserRemoteRepo(i()),
        ),
        Bind.factory<IOrderRepo>(
          (i) => FirebaseOrderRemoteRepo(i()),
        ),
        Bind.factory<IPdfService>(
          (i) => PdfService(),
        ),
        Bind.factory<IPrintService>(
          (i) => PrintService(),
        ),
        Bind.factory<IDoLogin>(
          (i) => DoLogin(i(), i()),
        ),
        Bind.factory<IDoLogout>(
          (i) => DoLogout(i()),
        ),
        Bind.factory<IGetCurrentUser>(
          (i) => GetCurrentUser(i(), i()),
        ),
        Bind.factory<IDeleteOrder>(
          (i) => DeleteOrder(i()),
        ),
        Bind.factory<IGetAllOrdersBySendDate>(
          (i) => GetAllOrdersBySendDate(i()),
        ),
        Bind.factory<IGetOrderByTypeAndNumber>(
          (i) => GetOrderByTypeAndNumber(i()),
        ),
        Bind.factory<ISaveOrder>(
          (i) => SaveOrder(i()),
        ),
        Bind.factory<IPrintOrdersReport>(
          (i) => PrintOrdersReport(i(), i()),
        ),
        Bind.singleton<AuthCubit>(
          (i) => AuthCubit(i(), i(), i())..fetchLoggedUser(),
        ),
        Bind.factory<OrderRegisterCubit>(
          (i) => OrderRegisterCubit(i(), i(), i()),
        ),
        Bind.factory<OrdersReportCubit>(
          (i) => OrdersReportCubit(i(), i()),
        ),
      ];
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/login');

    return MaterialApp.router(
      title: 'Controle de Pedidos - Prefeitura Municipal de Penápolis',
      themeMode: ThemeConfig.themeMode,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

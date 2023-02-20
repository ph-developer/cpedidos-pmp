import 'package:go_router/go_router.dart';

import 'src/auth/presentation/guards/auth_guard.dart';
import 'src/auth/presentation/guards/guest_guard.dart';
import 'src/auth/presentation/pages/login_page.dart';
import 'src/orders/presentation/pages/order_register_page.dart';
import 'src/orders/presentation/pages/orders_report_page.dart';

bool _initialized = false;

late GoRouter _router;
GoRouter get router => _router;

void setupRouter([String initialRoute = '/login']) {
  if (_initialized) return;
  _router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
        redirect: guestGuard,
      ),
      GoRoute(
        path: '/pedidos/cadastro',
        builder: (_, __) => const OrderRegisterPage(),
        redirect: authGuard,
      ),
      GoRoute(
        path: '/pedidos/relatorio',
        builder: (_, __) => const OrdersReportPage(),
        redirect: authGuard,
      ),
    ],
  );
  _initialized = true;
}

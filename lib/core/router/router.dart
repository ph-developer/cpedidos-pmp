import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/app/presentation/layouts/app_layout.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/catalog/presentation/pages/items_search_page.dart';
import '../../features/orders/presentation/pages/order_register_page.dart';
import '../../features/orders/presentation/pages/orders_search_page.dart';
import '../guards/auth_guard.dart';
import '../guards/guest_guard.dart';
import 'transitions.dart';

typedef Router = GoRouter;

late final Router router;

Future<void> setupRouter([String initialRoute = '/']) async {
  router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/login'),
      GoRoute(
        name: 'login',
        path: '/login',
        redirect: guestGuard,
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppLayout(child, state.fullpath),
        routes: [
          GoRoute(
            path: '/pedidos/cadastro',
            redirect: authGuard,
            pageBuilder: defaultTransition(const OrderRegisterPage()),
          ),
          GoRoute(
            path: '/pedidos/busca',
            redirect: authGuard,
            pageBuilder: defaultTransition(const OrdersSearchPage()),
          ),
          GoRoute(
            path: '/catalogo/busca',
            redirect: authGuard,
            pageBuilder: defaultTransition(const ItemsSearchPage()),
          ),
        ],
      ),
    ],
  );
}

extension RouterExtension on BuildContext {
  Future<void> navigateTo(String location) async {
    router.go(location);
  }
}

// coverage:ignore-file

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth/auth_module.dart';
import 'catalog/catalog_module.dart';
import 'orders/orders_module.dart';
import 'shared/config/theme/theme_config.dart';
import 'shared/services/error_service.dart';
import 'shared/services/error_service_impl.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/auth', module: AuthModule()),
        ModuleRoute('/pedidos', module: OrdersModule()),
        ModuleRoute('/catalogo', module: CatalogModule()),
        RedirectRoute('/', to: '/auth'),
      ];

  @override
  List<Bind> get binds => [
        Bind.factory<FirebaseAuth>(
          (i) => FirebaseAuth.instance,
        ),
        Bind.factory<FirebaseDatabase>(
          (i) => FirebaseDatabase.instance,
        ),
        Bind.factory<FirebaseFirestore>(
          (i) => FirebaseFirestore.instance,
        ),
        Bind.factory<IErrorService>(
          (i) => ErrorServiceImpl(),
        ),
      ];

  @override
  List<Module> get imports => [
        AuthModule(),
        OrdersModule(),
        CatalogModule(),
      ];
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/auth/login');

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

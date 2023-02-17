import 'package:flutter/material.dart';

import 'package:asuka/asuka.dart';

import '../router.dart';

import 'shared/themes/themes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Controle de Pedidos - Prefeitura Municipal de Penápolis',
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      builder: Asuka.builder,
      routerConfig: router,
    ); //added by extension
  }
}

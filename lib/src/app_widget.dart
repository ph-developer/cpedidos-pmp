import 'package:flutter/material.dart';

import '../router.dart';

import 'shared/themes/themes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Controle de Pedidos - Prefeitura Municipal de Penápolis',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
    ); //added by extension
  }
}

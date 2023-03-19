// coverage:ignore-file

import 'package:flutter/material.dart';

import 'core/boot/boot.dart';
import 'core/router/router.dart';
import 'core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const LogoFullscreenLoader(),
  );

  await Boot.run(
    () => runApp(
      MaterialApp.router(
        title: 'Controle de Pedidos - Prefeitura Municipal de Penápolis',
        themeMode: themeMode,
        theme: currentTheme,
        routerConfig: router,
      ),
    ),
  );
}

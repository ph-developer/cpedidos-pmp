import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';

import 'src/app_module.dart';
import 'src/shared/config/firebase/firebase_config.dart';
import 'src/shared/config/sentry/sentry_config.dart';
import 'src/shared/widgets/loaders/logo_fullscreen_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LogoFullscreenLoader());

  await Future.delayed(const Duration(seconds: 1));

  await FirebaseConfig.setup();

  await SentryConfig.setup(
    () => runApp(ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    )),
  );
}

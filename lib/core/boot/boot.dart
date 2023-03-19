import 'auth/auth_boot.dart';
import 'firebase/firebase_boot.dart';
import 'injection/injector_boot.dart';
import 'router/router_boot.dart';
import 'sentry/sentry_boot.dart';

abstract class Boot {
  static Future<void> run(Function() appRunner) async {
    await Future.delayed(const Duration(seconds: 1));
    await FirebaseBoot.run();
    await InjectorBoot.run();
    await AuthBoot.run();
    await RouterBoot.run();
    await SentryBoot.run(appRunner);
  }
}

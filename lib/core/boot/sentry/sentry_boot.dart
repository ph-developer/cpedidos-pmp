import 'package:sentry_flutter/sentry_flutter.dart';

abstract class SentryBoot {
  static Future<void> run(AppRunner appRunner) async {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = const String.fromEnvironment('SENTRY_DSN')
          ..tracesSampleRate = 1.0;
      },
      appRunner: appRunner,
    );
  }
}

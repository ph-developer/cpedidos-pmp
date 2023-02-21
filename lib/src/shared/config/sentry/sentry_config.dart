import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

abstract class SentryConfig {
  static Future<void> setup(FutureOr<void> Function()? appRunner) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = const String.fromEnvironment('SENTRY_DSN');
        options.tracesSampleRate = 1.0;
      },
      appRunner: appRunner,
    );
  }
}

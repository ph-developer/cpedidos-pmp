import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'error_service.dart';

class ErrorServiceImpl implements IErrorService {
  @override
  Future<void> reportException(
    Object exception,
    StackTrace? stackTrace,
  ) async {
    if (kDebugMode) {
      debugPrint(exception.toString());
      debugPrintStack(stackTrace: stackTrace);
    }

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}

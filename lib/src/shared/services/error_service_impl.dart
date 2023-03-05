import 'package:sentry_flutter/sentry_flutter.dart';

import 'error_service.dart';

class ErrorServiceImpl implements IErrorService {
  @override
  Future<void> reportException(
    Object exception,
    StackTrace? stackTrace,
  ) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}

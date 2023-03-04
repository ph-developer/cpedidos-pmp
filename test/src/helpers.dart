import 'package:flutter/material.dart';

void disableOverflowErrors() {
  FlutterError.onError = (
    FlutterErrorDetails details, {
    bool forceReport = false,
  }) {
    var ifIsOverflowError = false;

    // Detect overflow error.
    final exception = details.exception;
    if (exception is FlutterError) {
      ifIsOverflowError = !exception.diagnostics.any(
        (e) => e.value.toString().startsWith('A RenderFlex overflowed by'),
      );
    }

    // Ignore if is overflow error.
    if (!ifIsOverflowError) {
      FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    }
  };
}

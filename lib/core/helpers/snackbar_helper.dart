import 'package:flutter/material.dart';

import '../theme/theme.dart';

class SnackbarHelper {
  static SnackbarHelper? delegate;
  static Duration defaultDuration = const Duration(milliseconds: 3000);

  void showSuccessSnackbar(
    BuildContext context,
    String message, [
    Duration? duration,
  ]) {
    hideSnackbar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: duration ?? defaultDuration,
        backgroundColor: Colors.transparent,
        content: SuccessSnackbar(
          message: message,
          duration: duration ?? defaultDuration,
        ),
      ),
    );
  }

  void showErrorSnackbar(
    BuildContext context,
    String message, [
    Duration? duration,
  ]) {
    hideSnackbar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: duration ?? defaultDuration,
        backgroundColor: Colors.transparent,
        content: ErrorSnackbar(
          message: message,
          duration: duration ?? defaultDuration,
        ),
      ),
    );
  }

  void hideSnackbar(BuildContext context) {
    if (ScaffoldMessenger.of(context).mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
}

extension SnackbarHelperExt on BuildContext {
  SnackbarHelper get _snackbarHelper =>
      SnackbarHelper.delegate ?? SnackbarHelper();

  void showSuccessSnackbar(String message, [Duration? duration]) {
    _snackbarHelper.showSuccessSnackbar(this, message, duration);
  }

  void showErrorSnackbar(String message, [Duration? duration]) {
    _snackbarHelper.showErrorSnackbar(this, message, duration);
  }

  void hideSnackbar() {
    _snackbarHelper.hideSnackbar(this);
  }
}

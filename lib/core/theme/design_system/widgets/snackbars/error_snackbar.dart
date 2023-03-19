import 'package:flutter/material.dart';

import 'base_snackbar.dart';

class ErrorSnackbar extends StatelessWidget {
  final String message;
  final Duration duration;

  const ErrorSnackbar({
    super.key,
    required this.message,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSnackbar(
      message: message,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.error,
      progressBarColor: Theme.of(context).colorScheme.errorContainer,
      textColor: Theme.of(context).colorScheme.onError,
      icon: Icons.warning_amber_rounded,
    );
  }
}

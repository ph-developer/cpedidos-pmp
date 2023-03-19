import 'package:flutter/material.dart';

import 'base_snackbar.dart';

class SuccessSnackbar extends StatelessWidget {
  final String message;
  final Duration duration;

  const SuccessSnackbar({
    super.key,
    required this.message,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSnackbar(
      message: message,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      progressBarColor: Theme.of(context).colorScheme.tertiaryContainer,
      textColor: Theme.of(context).colorScheme.onTertiary,
      icon: Icons.check_circle_outline_rounded,
    );
  }
}

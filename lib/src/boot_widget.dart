import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'shared/themes/themes.dart';

class BootWidget extends StatefulWidget {
  final WidgetsBinding widgetsBinding;

  const BootWidget({
    required this.widgetsBinding,
    Key? key,
  }) : super(key: key);

  @override
  State<BootWidget> createState() => _BootWidgetState();
}

class _BootWidgetState extends State<BootWidget> {
  double get logoSize {
    final density = widget.widgetsBinding.window.devicePixelRatio;

    if (density <= 1.0) {
      return 178;
    } else if (density > 1.0 && density <= 1.5) {
      return 267;
    } else if (density > 1.5 && density <= 2.0) {
      return 357;
    } else if (density > 2.0 && density <= 3.0) {
      return 535;
    } else {
      return 714;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        widget.widgetsBinding.window.platformBrightness == Brightness.dark
            ? darkTheme
            : lightTheme;

    return Container(
      color: theme.colorScheme.background,
      child: Center(
        child: Lottie.asset(
          'assets/cart-icon-loader.json',
          height: logoSize * 1.5,
        ),
      ),
    );
  }
}

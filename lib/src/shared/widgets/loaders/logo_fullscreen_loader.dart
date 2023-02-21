import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import '../../themes/themes.dart';

class LogoFullscreenLoader extends StatelessWidget {
  const LogoFullscreenLoader({super.key});

  double get logoSize {
    final density = WidgetsBinding.instance.window.devicePixelRatio;

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
    return Container(
      color: systemTheme.colorScheme.background,
      child: Center(
        child: Lottie.asset(
          'assets/cart-icon-loader.json',
          height: logoSize * 1.5,
        ),
      ),
    );
  }
}

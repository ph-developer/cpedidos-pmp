import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef PageTransition = Page<dynamic> Function(BuildContext, GoRouterState);

const defaultTransition = fadeTransition;

PageTransition fadeTransition(Widget page) {
  return (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: page,
        barrierDismissible: true,
        barrierColor: Theme.of(context).colorScheme.background,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child,
          );
        },
      );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

import '../../features/auth/presentation/stores/auth_store.dart';
import '../injection/injector.dart';

Future<String?> guestGuard(BuildContext context, GoRouterState state) async {
  final authStore = inject<AuthStore>();

  if (authStore.isLoading) {
    await asyncWhen((_) => authStore.isLoading == false);
  }

  if (authStore.loggedUser == null) {
    return null;
  } else {
    return '/pedidos/cadastro';
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../../injector.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

Future<String?> guestGuard(BuildContext context, GoRouterState state) async {
  final AuthCubit cubit = inject();

  if (cubit.state is! AuthLoggedOutState) return '/pedidos/cadastro';

  return null;
}

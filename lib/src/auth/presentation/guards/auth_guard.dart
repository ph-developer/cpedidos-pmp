import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../../injector.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

Future<String?> authGuard(BuildContext context, GoRouterState state) async {
  final AuthCubit cubit = inject();

  if (cubit.state is! AuthLoggedInState) return '/login';

  return null;
}

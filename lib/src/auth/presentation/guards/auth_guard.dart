import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/login');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final cubit = Modular.get<AuthCubit>();

    if (cubit.state is LoadingState) {
      await cubit.stream.first;
    }

    return cubit.state is LoggedInState;
  }
}

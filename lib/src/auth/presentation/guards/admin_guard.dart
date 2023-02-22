import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class AdminGuard extends RouteGuard {
  AdminGuard() : super(redirectTo: '/auth/login');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final cubit = Modular.get<AuthCubit>();

    if (cubit.state is AuthLoadingState) {
      await cubit.stream.first;
    }

    if (cubit.state is! AuthLoggedInState) {
      return false;
    }

    return (cubit.state as AuthLoggedInState).loggedUser.isAdmin;
  }
}

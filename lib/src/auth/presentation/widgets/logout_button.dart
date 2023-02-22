import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/managers/snackbar_manager.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class LogoutButton extends StatelessWidget {
  final cubit = Modular.get<AuthCubit>();

  LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is AuthFailureState) {
          context.showErrorSnackBar(state.failure.message);
        } else if (state is AuthLoggedOutState) {
          Modular.to.pushReplacementNamed('/login');
        }
      },
      child: IconButton(
        icon: const Icon(Icons.logout_rounded),
        color: Theme.of(context).colorScheme.primary,
        onPressed: cubit.logout,
        tooltip: 'Sair',
      ),
    );
  }
}

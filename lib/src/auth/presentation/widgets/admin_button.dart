import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class AdminButton extends StatelessWidget {
  final cubit = Modular.get<AuthCubit>();

  AdminButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is! AuthLoggedInState || !state.loggedUser.isAdmin) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.admin_panel_settings_rounded),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => Modular.to.pushReplacementNamed('/admin'),
          tooltip: 'Painel de Administração',
        );
      },
    );
  }
}

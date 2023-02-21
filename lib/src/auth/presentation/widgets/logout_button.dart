import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injector.dart';
import '../../../../router.dart';
import '../../../shared/widgets/snack_bars/error_snack_bar.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class LogoutButton extends StatelessWidget {
  final cubit = inject<AuthCubit>();

  LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is AuthFailureState) {
          ErrorSnackBar(context, text: state.failure.message).show();
        } else if (state is AuthLoggedOutState) {
          router.pushReplacement('/login');
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

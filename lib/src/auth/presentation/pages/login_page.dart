import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../injector.dart';
import '../../../../router.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/inputs/password_input.dart';
import '../../../shared/widgets/inputs/text_input.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cubit = inject<AuthCubit>();

  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is AuthLoggedInState) {
          router.pushReplacement('/pedidos/cadastro');
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(context),
                  _buildLoginFormFields(context),
                  _buildActionsFormRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: SvgPicture.asset(
        'assets/logo.svg',
        height: 70,
      ),
    );
  }

  Widget _buildLoginFormFields(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is! AuthLoggingInState;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextInput(
                      isEnabled: isEnabled,
                      controller: emailEC,
                      label: 'Email',
                      autofocus: true,
                      onSubmitted: (_) {
                        if (emailEC.text.isNotEmpty &&
                            passwordEC.text.isNotEmpty) {
                          cubit.login(emailEC.text, passwordEC.text);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PasswordInput(
                      isEnabled: isEnabled,
                      controller: passwordEC,
                      label: 'Senha',
                      onSubmitted: (_) {
                        if (emailEC.text.isNotEmpty &&
                            passwordEC.text.isNotEmpty) {
                          cubit.login(emailEC.text, passwordEC.text);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionsFormRow(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is! AuthLoggingInState;

        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  isEnabled: isEnabled,
                  icon: Icons.login_rounded,
                  label: 'Entrar',
                  type: ButtonType.primary,
                  onPressed: () => cubit.login(emailEC.text, passwordEC.text),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

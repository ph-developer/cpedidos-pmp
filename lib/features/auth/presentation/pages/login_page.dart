import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/injection/injector.dart';
import '../../../../core/reactivity/obs_form.dart';
import '../../../../core/router/router.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/logged_user.dart';
import '../../domain/errors/failures.dart';
import '../stores/auth_store.dart';

enum _FormFields { email, password }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final reactionDisposers = <ReactionDisposer>[];
  final authStore = inject<AuthStore>();
  final formState = ObservableForm(_FormFields.values);

  @override
  void initState() {
    super.initState();
    reactionDisposers.addAll([
      reaction((_) => authStore.failure, _onFailure),
      reaction((_) => authStore.loggedUser, _onLoggedIn),
    ]);
  }

  @override
  void dispose() {
    formState.dispose();
    for (final dispose in reactionDisposers) {
      dispose();
    }
    super.dispose();
  }

  Future<void> _onFailure(AuthFailure? failure) async {
    if (failure != null) {
      context.showErrorSnackbar(failure.message);
    }
  }

  Future<void> _onLoggedIn(LoggedUser? loggedUser) async {
    if (loggedUser != null) {
      await context.navigateTo('/pedidos/cadastro');
    }
  }

  Future<void> _onSubmit([dynamic _]) async {
    await authStore.doLogin(formState.getValues());
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final isLoading = authStore.isLoading;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(36),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        height: 70,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextInput(
                                  isEnabled: !isLoading,
                                  controller: formState
                                      .getController(_FormFields.email),
                                  label: 'Email',
                                  autofocus: true,
                                  onSubmitted: _onSubmit,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: PasswordInput(
                                  isEnabled: !isLoading,
                                  controller: formState
                                      .getController(_FormFields.password),
                                  label: 'Senha',
                                  onSubmitted: _onSubmit,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: OutlineButton(
                              isEnabled: !isLoading,
                              icon: Icons.login_rounded,
                              label: 'Entrar',
                              type: ButtonType.primary,
                              onPressed: _onSubmit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

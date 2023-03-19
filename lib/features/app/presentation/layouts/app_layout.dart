import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/injection/injector.dart';
import '../../../../core/router/router.dart';
import '../../../auth/domain/entities/logged_user.dart';
import '../../../auth/domain/errors/failures.dart';
import '../../../auth/presentation/stores/auth_store.dart';
import '../../domain/entities/page_info.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String? currentRoutePath;

  const AppLayout(this.child, this.currentRoutePath, {super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final reactionDisposers = <ReactionDisposer>[];
  final authStore = inject<AuthStore>();
  final List<PageInfo> pageInfos = [
    const PageInfo(
      description: 'Cadastro de Pedidos',
      path: '/pedidos/cadastro',
      icon: Icons.edit_note_outlined,
    ),
    const PageInfo(
      description: 'Busca de Pedidos',
      path: '/pedidos/busca',
      icon: Icons.manage_search_rounded,
    ),
    const PageInfo(
      description: 'Busca de Materiais e Serviços',
      path: '/catalogo/busca',
      icon: Icons.menu_book_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    reactionDisposers.addAll([
      reaction((_) => authStore.failure, _onFailure),
      reaction((_) => authStore.loggedUser, _onLoggedOut),
    ]);
  }

  @override
  void dispose() {
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

  Future<void> _onLoggedOut(LoggedUser? loggedUser) async {
    if (loggedUser == null) {
      await context.navigateTo('/login');
    }
  }

  Future<void> _onNavigate(PageInfo pageInfo) async {
    await context.navigateTo(pageInfo.path);
  }

  Future<void> _onLogout([dynamic _]) async {
    await authStore.doLogout();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageInfo = pageInfos
        .firstWhere((pageInfo) => pageInfo.path == widget.currentRoutePath);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          currentPageInfo.icon,
          color: Theme.of(context).colorScheme.primary,
          weight: 2,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentPageInfo.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Observer(
                    builder: (_) {
                      final email = authStore.loggedUser?.email ?? '';

                      return Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
                ...pageInfos
                    .where(
                      (pageInfo) => pageInfo.path != widget.currentRoutePath,
                    )
                    .map(
                      (pageInfo) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          icon: Icon(pageInfo.icon),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () => _onNavigate(pageInfo),
                          tooltip: pageInfo.description,
                        ),
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: _onLogout,
                    tooltip: 'Sair',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1140
              ? (MediaQuery.of(context).size.width - 1140) / 2
              : 0,
        ),
        child: widget.child,
      ),
    );
  }
}

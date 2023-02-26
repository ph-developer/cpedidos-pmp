import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/do_login.dart';
import 'domain/usecases/do_logout.dart';
import 'domain/usecases/get_current_user.dart';
import 'external/datasources/auth_datasource_impl.dart';
import 'infra/datasources/auth_datasource.dart';
import 'infra/repositories/auth_repository_impl.dart';
import 'presentation/cubits/auth_cubit.dart';
import 'presentation/guards/guest_guard.dart';
import 'presentation/pages/login_page.dart';

class AuthModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/login',
          child: (_, __) => const LoginPage(),
          guards: [GuestGuard()],
        ),
        RedirectRoute('/', to: '/login'),
      ];

  @override
  List<Bind> get binds => [
        //! External
        Bind.factory<IAuthDatasource>(
          (i) => AuthDatasourceImpl(i()),
          export: true,
        ),

        //! Infra
        Bind.factory<IAuthRepository>(
          (i) => AuthRepositoryImpl(i(), i()),
          export: true,
        ),

        //! Domain
        Bind.factory<IDoLogin>(
          (i) => DoLogin(i()),
          export: true,
        ),
        Bind.factory<IDoLogout>(
          (i) => DoLogout(i()),
          export: true,
        ),
        Bind.factory<IGetCurrentUser>(
          (i) => GetCurrentUser(i()),
          export: true,
        ),

        //! Presentation
        Bind.singleton<AuthCubit>(
          (i) => AuthCubit(i(), i(), i())..fetchLoggedUser(),
          export: true,
        ),
      ];
}

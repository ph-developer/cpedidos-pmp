import 'package:flutter_modular/flutter_modular.dart';

import 'data/repositories/remote/firebase_auth_remote_repo.dart';
import 'data/repositories/remote/firebase_user_remote_repo.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/repositories/user_repo.dart';
import 'domain/usecases/do_login.dart';
import 'domain/usecases/do_logout.dart';
import 'domain/usecases/get_current_user.dart';
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
        Bind.factory<IAuthRepo>(
          (i) => FirebaseAuthRemoteRepo(i()),
          export: true,
        ),
        Bind.factory<IUserRepo>(
          (i) => FirebaseUserRemoteRepo(i()),
          export: true,
        ),
        Bind.factory<IDoLogin>(
          (i) => DoLogin(i(), i()),
          export: true,
        ),
        Bind.factory<IDoLogout>(
          (i) => DoLogout(i()),
          export: true,
        ),
        Bind.factory<IGetCurrentUser>(
          (i) => GetCurrentUser(i(), i()),
          export: true,
        ),
        Bind.singleton<AuthCubit>(
          (i) => AuthCubit(i(), i(), i())..fetchLoggedUser(),
          export: true,
        ),
      ];
}

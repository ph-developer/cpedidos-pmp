import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/user_repository.dart';
import 'domain/usecases/create_user.dart';
import 'external/datasources/account_datasource_impl.dart';
import 'external/datasources/profile_datasource_impl.dart';
import 'infra/datasources/account_datasource.dart';
import 'infra/datasources/profile_datasource.dart';
import 'infra/repositories/user_repository_impl.dart';

class AdminModule extends Module {
  @override
  List<ModularRoute> get routes => [];

  @override
  List<Bind> get binds => [
        //! External
        Bind.factory<IAccountDatasource>(
          (i) => AccountDatasourceImpl(i()),
          export: true,
        ),
        Bind.factory<IProfileDatasource>(
          (i) => ProfileDatasourceImpl(i()),
          export: true,
        ),

        //! Infra
        Bind.factory<IUserRepository>(
          (i) => UserRepositoryImpl(i(), i(), i()),
          export: true,
        ),

        //! Domain
        Bind.factory<ICreateUser>(
          (i) => CreateUser(i()),
          export: true,
        ),

        //! Presentation
      ];
}

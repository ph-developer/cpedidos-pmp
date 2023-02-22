import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/create_user.dart';

class AdminModule extends Module {
  @override
  List<ModularRoute> get routes => [];

  @override
  List<Bind> get binds => [
        // Repos
        // Services
        // Usecases
        Bind.factory<ICreateUser>(
          (i) => CreateUser(i()),
          export: true,
        ),
        // Cubits
      ];
}

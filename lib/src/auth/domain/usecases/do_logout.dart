import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';
import '../repositories/auth_repository.dart';

abstract class IDoLogout {
  AsyncResult<Unit, AuthFailure> call();
}

class DoLogout implements IDoLogout {
  final IAuthRepository _authRepository;

  DoLogout(this._authRepository);

  @override
  AsyncResult<Unit, AuthFailure> call() async {
    return _authRepository.logout();
  }
}

import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';
import '../repositories/auth_repository.dart';

abstract class IDoLogout {
  AsyncResult<Unit, AuthFailure> call();
}

class DoLogoutImpl implements IDoLogout {
  final IAuthRepository _authRepository;

  DoLogoutImpl(this._authRepository);

  @override
  AsyncResult<Unit, AuthFailure> call() async {
    return _authRepository.logout();
  }
}

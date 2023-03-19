import 'package:result_dart/result_dart.dart';

import '../entities/logged_user.dart';
import '../errors/failures.dart';
import '../repositories/auth_repository.dart';

abstract class IGetCurrentUser {
  AsyncResult<LoggedUser, AuthFailure> call();
}

class GetCurrentUserImpl implements IGetCurrentUser {
  final IAuthRepository _authRepository;

  GetCurrentUserImpl(this._authRepository);

  @override
  AsyncResult<LoggedUser, AuthFailure> call() async {
    return _authRepository.getCurrentUser();
  }
}

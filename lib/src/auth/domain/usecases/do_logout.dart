import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';
import '../repositories/auth_repo.dart';

abstract class IDoLogout {
  AsyncResult<bool, AuthFailure> call();
}

class DoLogout implements IDoLogout {
  final IAuthRepo _authRepo;

  DoLogout(this._authRepo);

  @override
  AsyncResult<bool, AuthFailure> call() async {
    return _authRepo.logout();
  }
}

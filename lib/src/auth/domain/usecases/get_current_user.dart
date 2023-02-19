import 'package:result_dart/result_dart.dart';

import '../entities/user.dart';
import '../errors/failures.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

abstract class IGetCurrentUser {
  AsyncResult<User, AuthFailure> call();
}

class GetCurrentUser implements IGetCurrentUser {
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;

  GetCurrentUser(this._authRepo, this._userRepo);

  @override
  AsyncResult<User, AuthFailure> call() async {
    return _authRepo
        .getCurrentUserId()
        .flatMap((userId) => _userRepo.getById(userId));
  }
}

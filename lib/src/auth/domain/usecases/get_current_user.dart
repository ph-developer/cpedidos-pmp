import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../entities/user.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

abstract class IGetCurrentUser {
  Future<User?> call();
}

class GetCurrentUser implements IGetCurrentUser {
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;

  GetCurrentUser(this._authRepo, this._userRepo);

  @override
  Future<User?> call() async {
    final userId = await _authRepo.getCurrentUserId();

    if (userId == null) return null;

    try {
      final user = await _userRepo.getById(userId);

      return user;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return null;
    }
  }
}

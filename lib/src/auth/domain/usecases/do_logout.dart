import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../repositories/auth_repo.dart';

abstract class IDoLogout {
  Future<bool> call();
}

class DoLogout implements IDoLogout {
  final IAuthRepo _authRepo;

  DoLogout(this._authRepo);

  @override
  Future<bool> call() async {
    try {
      final result = await _authRepo.logout();

      if (!result) {
        notifyError('Ocorreu um erro ao efetuar o logout.');
      }

      return result;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return false;
    }
  }
}

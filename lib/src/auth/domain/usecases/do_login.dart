import 'package:email_validator/email_validator.dart';

import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../entities/user.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

abstract class IDoLogin {
  Future<User?> call(String email, String password);
}

class DoLogin implements IDoLogin {
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;

  DoLogin(this._authRepo, this._userRepo);

  @override
  Future<User?> call(String email, String password) async {
    try {
      if (email.isEmpty) {
        notifyError('O campo "email" deve ser preenchido.');
        return null;
      }

      if (password.isEmpty) {
        notifyError('O campo "senha" deve ser preenchido.');
        return null;
      }

      if (!EmailValidator.validate(email)) {
        notifyError('O email informado possui um formato inválido.');
        return null;
      }

      final userId = await _authRepo.login(email, password);
      final user = await _userRepo.getById(userId);

      return user;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return null;
    }
  }
}

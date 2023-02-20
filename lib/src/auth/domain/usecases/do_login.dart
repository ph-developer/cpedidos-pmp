import 'package:email_validator/email_validator.dart';
import 'package:result_dart/result_dart.dart';

import '../entities/user.dart';
import '../errors/failures.dart';
import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

abstract class IDoLogin {
  AsyncResult<User, AuthFailure> call(String email, String password);
}

class DoLogin implements IDoLogin {
  final IAuthRepo _authRepo;
  final IUserRepo _userRepo;

  DoLogin(this._authRepo, this._userRepo);

  @override
  AsyncResult<User, AuthFailure> call(String email, String password) async {
    if (email.isEmpty) {
      return const Failure(
        InvalidInput('O campo "email" deve ser preenchido.'),
      );
    }

    if (password.isEmpty) {
      return const Failure(
        InvalidInput('O campo "senha" deve ser preenchido.'),
      );
    }

    if (!EmailValidator.validate(email)) {
      return const Failure(
        InvalidInput('O email informado possui um formato inválido.'),
      );
    }

    return _authRepo
        .login(email, password)
        .flatMap((userId) => _userRepo.getById(userId));
  }
}

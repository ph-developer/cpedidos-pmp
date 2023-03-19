import 'package:email_validator/email_validator.dart';
import 'package:result_dart/result_dart.dart';

import '../entities/logged_user.dart';
import '../errors/failures.dart';
import '../repositories/auth_repository.dart';

abstract class IDoLogin {
  AsyncResult<LoggedUser, AuthFailure> call(
    String email,
    String password,
  );
}

class DoLoginImpl implements IDoLogin {
  final IAuthRepository _authRepository;

  DoLoginImpl(this._authRepository);

  @override
  AsyncResult<LoggedUser, AuthFailure> call(
    String email,
    String password,
  ) async {
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

    return _authRepository.login(email, password);
  }
}

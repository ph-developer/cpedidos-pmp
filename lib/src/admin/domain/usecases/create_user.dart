import 'package:email_validator/email_validator.dart';
import 'package:result_dart/result_dart.dart';

import '../entities/user.dart';
import '../errors/failures.dart';
import '../repositories/user_repo.dart';

abstract class ICreateUser {
  AsyncResult<User, AdminFailure> call(User user);
}

class CreateUser implements ICreateUser {
  final IUserRepo _userRepo;

  CreateUser(this._userRepo);

  @override
  AsyncResult<User, AdminFailure> call(User user) async {
    if (user.name.isEmpty) {
      return const Failure(
        InvalidInput('O campo "nome" deve ser preenchido.'),
      );
    }

    if (user.email.isEmpty) {
      return const Failure(
        InvalidInput('O campo "email" deve ser preenchido.'),
      );
    }

    if (!EmailValidator.validate(user.email)) {
      return const Failure(
        InvalidInput('O email informado possui um formato inválido.'),
      );
    }

    return _userRepo.create(user);
  }
}

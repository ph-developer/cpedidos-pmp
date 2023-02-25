import 'package:email_validator/email_validator.dart';
import 'package:result_dart/result_dart.dart';

import '../../../shared/helpers/string_generator.dart';
import '../entities/user.dart';
import '../errors/failures.dart';
import '../repositories/user_repository.dart';

abstract class ICreateUser {
  AsyncResult<User, AdminFailure> call(
      String email, String password, String name, bool isAdmin);
}

class CreateUserImpl implements ICreateUser {
  final IUserRepository _userRepository;

  CreateUserImpl(this._userRepository);

  @override
  AsyncResult<User, AdminFailure> call(
      String email, String password, String name, bool isAdmin) async {
    if (name.isEmpty) {
      return const Failure(AdminFailure.nameCantBeEmpty);
    }

    if (email.isEmpty) {
      return const Failure(AdminFailure.emailCantBeEmpty);
    }

    if (!EmailValidator.validate(email)) {
      return const Failure(AdminFailure.invalidEmail);
    }

    if (password.isEmpty) {
      password = generateRandomString(12);
    }

    return _userRepository.createUser(email, password, name, isAdmin);
  }
}

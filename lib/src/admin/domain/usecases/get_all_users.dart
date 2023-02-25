import 'package:result_dart/result_dart.dart';

import '../entities/user.dart';
import '../errors/failures.dart';
import '../repositories/user_repository.dart';

abstract class IGetAllUsers {
  AsyncResult<List<User>, AdminFailure> call();
}

class GetAllUsersImpl implements IGetAllUsers {
  final IUserRepository _userRepository;

  GetAllUsersImpl(this._userRepository);

  @override
  AsyncResult<List<User>, AdminFailure> call() async {
    return _userRepository.getAllUsers();
  }
}

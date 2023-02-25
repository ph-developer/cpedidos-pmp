import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';
import '../repositories/user_repository.dart';

abstract class IDeleteUser {
  AsyncResult<bool, AdminFailure> call(String id);
}

class DeleteUserImpl implements IDeleteUser {
  final IUserRepository _userRepository;

  DeleteUserImpl(this._userRepository);

  @override
  AsyncResult<bool, AdminFailure> call(String id) async {
    if (id.isEmpty) {
      return const Failure(AdminFailure.idCantBeEmpty);
    }

    return _userRepository.deleteUser(id);
  }
}

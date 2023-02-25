import 'package:result_dart/result_dart.dart';

import '../entities/user.dart';
import '../errors/failures.dart';

abstract class IUserRepository {
  AsyncResult<User, AdminFailure> createUser(
      String email, String password, String name, bool isAdmin);
}

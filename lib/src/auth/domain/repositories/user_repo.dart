import 'package:result_dart/result_dart.dart';

import '../entities/user.dart';
import '../errors/failures.dart';

abstract class IUserRepo {
  AsyncResult<User, AuthFailure> getById(String id);
}

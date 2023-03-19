import 'package:result_dart/result_dart.dart';

import '../entities/logged_user.dart';
import '../errors/failures.dart';

abstract class IAuthRepository {
  AsyncResult<LoggedUser, AuthFailure> login(
    String email,
    String password,
  );
  AsyncResult<Unit, AuthFailure> logout();
  AsyncResult<LoggedUser, AuthFailure> getCurrentUser();
}

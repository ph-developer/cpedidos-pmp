import 'package:result_dart/result_dart.dart';

import '../errors/failures.dart';

abstract class IAuthRepo {
  AsyncResult<String, AuthFailure> login(String email, String password);
  AsyncResult<bool, AuthFailure> logout();
  AsyncResult<String, AuthFailure> getCurrentUserId();
}

import '../models/logged_user_model.dart';

abstract class IAuthDatasource {
  Future<LoggedUserModel> login(String email, String password);
  Future<bool> logout();
  Future<LoggedUserModel> getCurrentUser();
}

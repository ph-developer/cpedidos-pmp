import '../entities/user.dart';

abstract class IUserRepo {
  Future<User> getById(String id);
}

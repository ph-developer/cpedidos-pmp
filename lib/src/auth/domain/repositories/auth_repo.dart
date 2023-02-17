abstract class IAuthRepo {
  Future<String> login(String email, String password);
  Future<bool> logout();
  Future<String?> getCurrentUserId();
  Stream<String?> currentUserIdChanged();
}

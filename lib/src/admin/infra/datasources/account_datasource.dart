abstract class IAccountDatasource {
  Future<String> createAccount(String email, String password);
  Future<bool> deleteAccount(String id);
}

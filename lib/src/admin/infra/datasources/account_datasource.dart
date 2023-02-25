abstract class IAccountDatasource {
  Future<String> createAccount(String email, String password);
}

abstract class IProfileDatasource {
  Future<Map<String, dynamic>> createProfile(
      String id, String name, bool isAdmin);
}

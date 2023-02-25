abstract class IProfileDatasource {
  Future<Map<String, dynamic>> createProfile(
      String id, String email, String name, bool isAdmin);
  Future<bool> deleteProfile(String id);
  Future<List<Map<String, dynamic>>> getAllProfiles();
}

import 'package:firebase_database/firebase_database.dart';

import '../../infra/datasources/profile_datasource.dart';

class ProfileDatasourceImpl implements IProfileDatasource {
  final FirebaseDatabase _database;

  ProfileDatasourceImpl(this._database);

  @override
  Future<Map<String, dynamic>> createProfile(
      String id, String name, bool isAdmin) async {
    final profileRef = _database.ref('users/$id');
    final profileMap = {
      'id': id,
      'name': name,
      'isAdmin': isAdmin,
    };

    await profileRef.set(profileMap);

    return profileMap;
  }
}

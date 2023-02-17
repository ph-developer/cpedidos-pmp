import 'package:firebase_database/firebase_database.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repo.dart';
import '../../dtos/user_dto.dart';
import '../../errors/failures.dart';

class FirebaseUserRemoteRepo implements IUserRepo {
  final FirebaseDatabase _database;

  FirebaseUserRemoteRepo(this._database);

  @override
  Future<User> getById(String id) async {
    try {
      final userRef = _database.ref('users/$id');
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        throw GetUserFailure(
          'Os dados do usuário não foram encontrados no banco de dados.',
        );
      }

      final userMap = userSnapshot.value as Map<String, dynamic>;

      return UserDTO.fromMap(userMap);
    } on GetUserFailure {
      rethrow;
    } catch (e) {
      throw GetUserFailure();
    }
  }
}

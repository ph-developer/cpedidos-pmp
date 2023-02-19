import 'package:firebase_database/firebase_database.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/errors/failures.dart';
import '../../../domain/repositories/user_repo.dart';
import '../../dtos/user_dto.dart';

class FirebaseUserRemoteRepo implements IUserRepo {
  final FirebaseDatabase _database;

  FirebaseUserRemoteRepo(this._database);

  @override
  AsyncResult<User, AuthFailure> getById(String id) async {
    final userRef = _database.ref('users/$id');
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      return Failure(UserDataNotFound());
    }

    final userMap = userSnapshot.value as Map<String, dynamic>;
    final user = UserDTO.fromMap(userMap);

    return Success(user);
  }
}

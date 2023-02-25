import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/errors/failures.dart';
import '../../infra/datasources/auth_datasource.dart';
import '../../infra/models/logged_user_model.dart';

class AuthDatasourceImpl implements IAuthDatasource {
  final FirebaseAuth _firebaseAuth;

  AuthDatasourceImpl(this._firebaseAuth);

  @override
  Future<LoggedUserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user!;
      final userId = firebaseUser.uid;
      final userEmail = firebaseUser.email;
      final userMap = {'id': userId, 'email': userEmail};
      final user = LoggedUserModel.fromMap(userMap);

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          throw const UserDisabled();
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          throw const InvalidCredentials();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<bool> logout() async {
    await _firebaseAuth.signOut();

    return true;
  }

  @override
  Future<LoggedUserModel> getCurrentUser() async {
    var firebaseUser = _firebaseAuth.currentUser;

    firebaseUser ??= await _firebaseAuth.authStateChanges().first;

    if (firebaseUser == null) {
      throw const UserUnauthenticated();
    }

    final userId = firebaseUser.uid;
    final userEmail = firebaseUser.email;
    final userMap = {'id': userId, 'email': userEmail};
    final user = LoggedUserModel.fromMap(userMap);

    return user;
  }
}

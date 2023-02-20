import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/errors/failures.dart';
import '../../../domain/repositories/auth_repo.dart';

class FirebaseAuthRemoteRepo implements IAuthRepo {
  final FirebaseAuth _auth;

  FirebaseAuthRemoteRepo(this._auth);

  @override
  AsyncResult<String, AuthFailure> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        return const Failure(InvalidCredentials());
      }

      final userId = result.user!.uid;

      return Success(userId);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          return const Failure(UserDisabled());
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          return const Failure(InvalidCredentials());
        default:
          rethrow;
      }
    }
  }

  @override
  AsyncResult<bool, AuthFailure> logout() async {
    await _auth.signOut();

    return const Success(true);
  }

  @override
  AsyncResult<String, AuthFailure> getCurrentUserId() async {
    var user = _auth.currentUser;

    user ??= await _auth.authStateChanges().first;

    if (user == null) {
      return const Failure(UserUnauthenticated());
    }

    final userId = user.uid;

    return Success(userId);
  }
}

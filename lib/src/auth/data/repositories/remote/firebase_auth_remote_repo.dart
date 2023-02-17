import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/repositories/auth_repo.dart';
import '../../errors/failures.dart';

class FirebaseAuthRemoteRepo implements IAuthRepo {
  final FirebaseAuth _auth;

  FirebaseAuthRemoteRepo(this._auth);

  @override
  Future<String> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) throw LoginFailure('Credenciais inválidas.');

      return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          throw LoginFailure('O usuário informado está desativado.');
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          throw LoginFailure('Credenciais inválidas.');
        default:
          throw LoginFailure();
      }
    } on LoginFailure {
      rethrow;
    } catch (e) {
      throw LoginFailure();
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw LogoutFailure();
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    var user = _auth.currentUser;

    user ??= await _auth.authStateChanges().first;

    return user?.uid;
  }

  @override
  Stream<String?> currentUserIdChanged() {
    return _auth.authStateChanges().map((user) {
      return user?.uid;
    });
  }
}

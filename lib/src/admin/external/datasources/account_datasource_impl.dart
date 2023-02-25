import '../../domain/errors/failures.dart';
import '../../infra/datasources/account_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountDatasourceImpl implements IAccountDatasource {
  final FirebaseAuth _auth;

  AccountDatasourceImpl(this._auth);

  @override
  Future<String> createAccount(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credentials.user!.uid;

      return userId;
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'email-already-in-use':
          throw AdminFailure.emailAlreadyInUse;
        case 'invalid-email':
          throw AdminFailure.invalidEmail;
        case 'operation-not-allowed':
          throw AdminFailure.operationNotAllowed;
        case 'weak-password':
          throw AdminFailure.weakPassword;
        default:
          rethrow;
      }
    }
  }
}

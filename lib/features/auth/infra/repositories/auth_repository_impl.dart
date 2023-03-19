import 'package:result_dart/result_dart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/logged_user.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl extends IAuthRepository {
  final IErrorHandler _errorHandler;
  final IAuthDatasource _authDatasource;

  AuthRepositoryImpl(this._errorHandler, this._authDatasource);

  @override
  AsyncResult<LoggedUser, AuthFailure> login(
    String email,
    String password,
  ) async {
    try {
      final loggedUser = await _authDatasource.login(email, password);

      return Success(loggedUser);
    } on AuthFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<Unit, AuthFailure> logout() async {
    try {
      await _authDatasource.logout();

      return const Success(unit);
    } on AuthFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<LoggedUser, AuthFailure> getCurrentUser() async {
    try {
      final loggedUser = await _authDatasource.getCurrentUser();

      return Success(loggedUser);
    } on AuthFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }
}

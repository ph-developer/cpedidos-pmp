// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../domain/entities/logged_user.dart';
import '../../domain/errors/failures.dart';
import '../../domain/usecases/do_login.dart';
import '../../domain/usecases/do_logout.dart';
import '../../domain/usecases/get_current_user.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final IGetCurrentUser _getCurrentUser;
  final IDoLogin _doLogin;
  final IDoLogout _doLogout;

  _AuthStoreBase(
    this._getCurrentUser,
    this._doLogin,
    this._doLogout,
  );

  @observable
  bool isLoading = false;

  @observable
  LoggedUser? loggedUser;

  @observable
  AuthFailure? failure;

  @action
  Future<void> fetchLoggedUser() async {
    isLoading = true;

    final result = await _getCurrentUser();
    result.fold(
      (user) => loggedUser = user,
      (failure) => loggedUser = null,
    );

    isLoading = false;
  }

  @action
  Future<void> doLogin(Map<String, String> payload) async {
    isLoading = true;
    failure = null;

    final email = payload['email'] ?? '';
    final password = payload['password'] ?? '';
    final result = await _doLogin(email, password);
    result.fold(
      (user) => loggedUser = user,
      (failure) => this.failure = failure,
    );

    isLoading = false;
  }

  @action
  Future<void> doLogout() async {
    isLoading = true;
    failure = null;

    final result = await _doLogout();
    result.fold(
      (_) => loggedUser = null,
      (failure) => this.failure = failure,
    );

    isLoading = false;
  }
}

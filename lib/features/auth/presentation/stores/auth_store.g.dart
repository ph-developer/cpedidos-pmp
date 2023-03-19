// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_AuthStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$loggedUserAtom =
      Atom(name: '_AuthStoreBase.loggedUser', context: context);

  @override
  LoggedUser? get loggedUser {
    _$loggedUserAtom.reportRead();
    return super.loggedUser;
  }

  @override
  set loggedUser(LoggedUser? value) {
    _$loggedUserAtom.reportWrite(value, super.loggedUser, () {
      super.loggedUser = value;
    });
  }

  late final _$failureAtom =
      Atom(name: '_AuthStoreBase.failure', context: context);

  @override
  AuthFailure? get failure {
    _$failureAtom.reportRead();
    return super.failure;
  }

  @override
  set failure(AuthFailure? value) {
    _$failureAtom.reportWrite(value, super.failure, () {
      super.failure = value;
    });
  }

  late final _$fetchLoggedUserAsyncAction =
      AsyncAction('_AuthStoreBase.fetchLoggedUser', context: context);

  @override
  Future<void> fetchLoggedUser() {
    return _$fetchLoggedUserAsyncAction.run(() => super.fetchLoggedUser());
  }

  late final _$doLoginAsyncAction =
      AsyncAction('_AuthStoreBase.doLogin', context: context);

  @override
  Future<void> doLogin(Map<String, String> payload) {
    return _$doLoginAsyncAction.run(() => super.doLogin(payload));
  }

  late final _$doLogoutAsyncAction =
      AsyncAction('_AuthStoreBase.doLogout', context: context);

  @override
  Future<void> doLogout() {
    return _$doLogoutAsyncAction.run(() => super.doLogout());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
loggedUser: ${loggedUser},
failure: ${failure}
    ''';
  }
}

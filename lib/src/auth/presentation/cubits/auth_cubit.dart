import 'package:bloc/bloc.dart';

import '../../../shared/errors/failure.dart';
import '../../domain/usecases/do_login.dart';
import '../../domain/usecases/do_logout.dart';
import '../../domain/usecases/get_current_user.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IGetCurrentUser _getCurrentUser;
  final IDoLogin _doLogin;
  final IDoLogout _doLogout;

  AuthCubit(
    this._getCurrentUser,
    this._doLogin,
    this._doLogout,
  ) : super(AuthInitialState());

  Future<void> fetchLoggedUser() async {
    try {
      emit(AuthLoadingState());
      final currentUser = await _getCurrentUser();
      if (currentUser != null) {
        emit(AuthLoggedInState(loggedUser: currentUser));
      } else {
        emit(AuthLoggedOutState());
      }
    } on Failure catch (failure) {
      emit(AuthFailureState(failure: failure));
      emit(AuthLoggedOutState());
    }
  }

  Future<void> login(String email, String password) async {
    if (state is! AuthLoggedOutState) return;
    try {
      emit(AuthLoggingInState());
      final currentUser = await _doLogin(email, password);
      if (currentUser != null) {
        emit(AuthLoggedInState(loggedUser: currentUser));
      } else {
        emit(AuthLoggedOutState());
      }
    } on Failure catch (failure) {
      emit(AuthFailureState(failure: failure));
    }
  }

  Future<void> logout() async {
    if (state is! AuthLoggedInState) return;
    final loggedUser = (state as AuthLoggedInState).loggedUser;
    try {
      emit(AuthLoggingOutState());
      final result = await _doLogout();
      if (result) {
        emit(AuthLoggedOutState());
      } else {
        emit(AuthLoggedInState(loggedUser: loggedUser));
      }
    } on Failure catch (failure) {
      emit(AuthFailureState(failure: failure));
    }
  }
}

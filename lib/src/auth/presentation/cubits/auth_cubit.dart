import 'package:bloc/bloc.dart';

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
    emit(AuthLoadingState());

    final result = await _getCurrentUser();

    result.fold((currentUser) {
      emit(AuthLoggedInState(loggedUser: currentUser));
    }, (failure) {
      emit(AuthFailureState(failure: failure));
      emit(AuthLoggedOutState());
    });
  }

  Future<void> login(String email, String password) async {
    if (state is! AuthLoggedOutState) return;
    emit(AuthLoggingInState());

    final result = await _doLogin(email, password);

    result.fold((currentUser) {
      emit(AuthLoggedInState(loggedUser: currentUser));
    }, (failure) {
      emit(AuthFailureState(failure: failure));
      emit(AuthLoggedOutState());
    });
  }

  Future<void> logout() async {
    if (state is! AuthLoggedInState) return;
    final loggedUser = (state as AuthLoggedInState).loggedUser;
    emit(AuthLoggingOutState());

    final result = await _doLogout();

    result.fold((success) {
      emit(AuthLoggedOutState());
    }, (failure) {
      emit(AuthFailureState(failure: failure));
      emit(AuthLoggedInState(loggedUser: loggedUser));
    });
  }
}

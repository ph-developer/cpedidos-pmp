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
  ) : super(InitialState());

  Future<void> fetchLoggedUser() async {
    emit(LoadingState());

    final result = await _getCurrentUser();

    result.fold((currentUser) {
      emit(LoggedInState(loggedUser: currentUser));
    }, (failure) {
      emit(FailureState(failure: failure));
      emit(LoggedOutState());
    });
  }

  Future<void> login(String email, String password) async {
    if (state is! LoggedOutState) return;
    emit(LoggingInState());

    final result = await _doLogin(email, password);

    result.fold((currentUser) {
      emit(LoggedInState(loggedUser: currentUser));
    }, (failure) {
      emit(FailureState(failure: failure));
      emit(LoggedOutState());
    });
  }

  Future<void> logout() async {
    if (state is! LoggedInState) return;
    final loggedUser = (state as LoggedInState).loggedUser;
    emit(LoggingOutState());

    final result = await _doLogout();

    result.fold((success) {
      emit(LoggedOutState());
    }, (failure) {
      emit(FailureState(failure: failure));
      emit(LoggedInState(loggedUser: loggedUser));
    });
  }
}

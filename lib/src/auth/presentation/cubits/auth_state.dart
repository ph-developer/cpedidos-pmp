import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/errors/failures.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoggingInState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoggedInState extends AuthState {
  final User loggedUser;

  AuthLoggedInState({required this.loggedUser});

  @override
  List<Object> get props => [loggedUser];
}

class AuthLoggingOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthFailureState extends AuthState {
  final AuthFailure failure;

  AuthFailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}

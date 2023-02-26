import 'package:equatable/equatable.dart';

import '../../domain/entities/logged_user.dart';
import '../../domain/errors/failures.dart';

abstract class AuthState extends Equatable {}

class InitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggingInState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends AuthState {
  final LoggedUser loggedUser;

  LoggedInState({required this.loggedUser});

  @override
  List<Object> get props => [loggedUser];
}

class LoggingOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class FailureState extends AuthState {
  final AuthFailure failure;

  FailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}

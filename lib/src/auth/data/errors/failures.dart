import '../../../shared/errors/failure.dart';

class LoginFailure extends Failure {
  LoginFailure([
    String message = 'Ocorreu um erro ao efetuar o login.',
  ]) : super(message);
}

class LogoutFailure extends Failure {
  LogoutFailure([
    String message = 'Ocorreu um erro ao efetuar o logout.',
  ]) : super(message);
}

class GetUserFailure extends Failure {
  GetUserFailure([
    String message =
        'Ocorreu um erro ao carregar os dados cadastrais do usuário.',
  ]) : super(message);
}

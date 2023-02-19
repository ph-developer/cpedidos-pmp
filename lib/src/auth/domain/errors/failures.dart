abstract class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);
}

class InvalidInput extends AuthFailure {
  InvalidInput(super.message);
}

class UserDataNotFound extends AuthFailure {
  UserDataNotFound()
      : super('Os dados do usuário não foram encontrados no banco de dados.');
}

class InvalidCredentials extends AuthFailure {
  InvalidCredentials() : super('Credenciais inválidas.');
}

class UserDisabled extends AuthFailure {
  UserDisabled() : super('O usuário informado está desativado.');
}

class UserUnauthenticated extends AuthFailure {
  UserUnauthenticated() : super('Usuário não autenticado.');
}

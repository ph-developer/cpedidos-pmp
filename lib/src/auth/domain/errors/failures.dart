abstract class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);
}

class InvalidInput extends AuthFailure {
  const InvalidInput(super.message);
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials() : super('Credenciais inválidas.');
}

class UserDisabled extends AuthFailure {
  const UserDisabled() : super('O usuário informado está desativado.');
}

class UserUnauthenticated extends AuthFailure {
  const UserUnauthenticated() : super('Usuário não autenticado.');
}

class UnknownError extends AuthFailure {
  const UnknownError() : super('Ocorreu um erro desconhecido.');
}

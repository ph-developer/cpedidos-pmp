import { Failure } from 'src/features/shared/errors/failures';

export abstract class AuthFailure extends Failure {
  //
}

export class InvalidInput extends AuthFailure {
  //
}

export class UserUnauthenticated extends AuthFailure {
  constructor() {
    super('Usuário não autenticado.');
  }
}

export class InvalidCredentials extends AuthFailure {
  constructor() {
    super('Credenciais inválidas.');
  }
}

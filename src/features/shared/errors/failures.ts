export abstract class Failure {
  readonly message: string;

  constructor(message: string) {
    this.message = message;
  }
}

export class UnknownError extends Failure {
  constructor() {
    super('Ocorreu um erro desconhecido.');
  }
}

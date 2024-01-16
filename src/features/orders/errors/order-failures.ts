import { Failure } from 'src/features/shared/errors/failures';

export abstract class OrderFailure extends Failure {
  //
}

export class InvalidInput extends OrderFailure {
  //
}

export class OrderNotFound extends OrderFailure {
  constructor() {
    super('Pedido não encontrado.');
  }
}

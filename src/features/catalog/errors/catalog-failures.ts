import { Failure } from 'src/features/shared/errors/failures';

export abstract class CatalogFailure extends Failure {
  //
}

export class InvalidInput extends CatalogFailure {
  //
}

import { CatmatRepository } from 'src/features/catalog/repositories/catmat-repository';
import { Material } from 'src/features/catalog/types/material';
import { InvalidInput } from 'src/features/orders/errors/order-failures';

export const CatmatRepositoryValidatorDecorator = (
  decorated: CatmatRepository,
): CatmatRepository => ({
  ...decorated,

  /**
   * Validate arguments and return decorated method.
   *
   * @param code
   * @throws InvalidInput
   */
  async getMaterialsByCode(code: string): Promise<Material[]> {
    if (code === '') {
      throw new InvalidInput('O campo "código" deve ser preenchido.');
    }
    return decorated.getMaterialsByCode(code.toUpperCase());
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param query
   * @throws InvalidInput
   */
  async getMaterialsByDescription(query: string): Promise<Material[]> {
    if (query === '') {
      throw new InvalidInput('O campo "descrição" deve ser preenchido.');
    }
    return decorated.getMaterialsByDescription(query.toUpperCase());
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param query
   * @throws InvalidInput
   */
  async getMaterialsByGroupDescription(query: string): Promise<Material[]> {
    if (query === '') {
      throw new InvalidInput('O campo "descrição do grupo" deve ser preenchido.');
    }
    return decorated.getMaterialsByGroupDescription(query.toUpperCase());
  },
});

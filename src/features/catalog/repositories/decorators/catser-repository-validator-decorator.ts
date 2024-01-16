import { CatserRepository } from 'src/features/catalog/repositories/catser-repository';
import { Service } from 'src/features/catalog/types/service';
import { InvalidInput } from 'src/features/catalog/errors/catalog-failures';

export const CatserRepositoryValidatorDecorator = (
  decorated: CatserRepository,
): CatserRepository => ({
  ...decorated,

  /**
   * Validate arguments and return decorated method.
   *
   * @param code
   * @throws InvalidInput
   */
  async getServicesByCode(code: string): Promise<Service[]> {
    if (code === '') {
      throw new InvalidInput('O campo "código" deve ser preenchido.');
    }
    return decorated.getServicesByCode(code.toUpperCase());
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param query
   * @throws InvalidInput
   */
  async getServicesByDescription(query: string): Promise<Service[]> {
    if (query === '') {
      throw new InvalidInput('O campo "descrição" deve ser preenchido.');
    }
    return decorated.getServicesByDescription(query.toUpperCase());
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param query
   * @throws InvalidInput
   */
  async getServicesByGroupDescription(query: string): Promise<Service[]> {
    if (query === '') {
      throw new InvalidInput('O campo "descrição do grupo" deve ser preenchido.');
    }
    return decorated.getServicesByGroupDescription(query.toUpperCase());
  },
});

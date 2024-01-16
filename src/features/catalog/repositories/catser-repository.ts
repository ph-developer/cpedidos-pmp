import { Service } from 'src/features/catalog/types/service';
import { CatserRepositoryImpl } from 'src/features/catalog/repositories/catser-repository-impl';
import {
  CatserRepositoryValidatorDecorator,
} from 'src/features/catalog/repositories/decorators/catser-repository-validator-decorator';

export interface CatserRepository {
  /**
   * Retrieve a Service list by code.
   *
   * @param code
   */
  getServicesByCode: (code: string) => Promise<Service[]>;

  /**
   * Retrieve a Service list by description.
   *
   * @param query
   */
  getServicesByDescription: (query: string) => Promise<Service[]>;

  /**
   * Retrieve a Service list by group description.
   *
   * @param query
   */
  getServicesByGroupDescription: (query: string) => Promise<Service[]>;
}

export const useCatserRepository = () => CatserRepositoryValidatorDecorator(
  CatserRepositoryImpl(),
);

import { Material } from 'src/features/catalog/types/material';
import { CatmatRepositoryImpl } from 'src/features/catalog/repositories/catmat-repository-impl';
import {
  CatmatRepositoryValidatorDecorator,
} from 'src/features/catalog/repositories/decorators/catmat-repository-validator-decorator';

export interface CatmatRepository {
  /**
   * Retrieve a Material list by code.
   *
   * @param code
   */
  getMaterialsByCode: (code: string) => Promise<Material[]>;

  /**
   * Retrieve a Material list by description.
   *
   * @param query
   */
  getMaterialsByDescription: (query: string) => Promise<Material[]>;

  /**
   * Retrieve a Material list by group description.
   *
   * @param query
   */
  getMaterialsByGroupDescription: (query: string) => Promise<Material[]>;
}

export const useCatmatRepository = () => CatmatRepositoryValidatorDecorator(
  CatmatRepositoryImpl(),
);

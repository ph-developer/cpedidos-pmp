import { CatmatRepository } from 'src/features/catalog/repositories/catmat-repository';
import { Material } from 'src/features/catalog/types/material';
import { catmatMapper } from 'src/features/catalog/repositories/mappers/catmat-mapper';
import { Catmat } from 'src/features/catalog/types/catmat';
import { materialMapper } from 'src/features/catalog/repositories/mappers/material-mapper';
import { hasQuery } from 'src/features/shared/utils/string';

const getCatmat = async (): Promise<Catmat> => {
  const json = (await import('src/features/catalog/assets/catmat.min.json')).default;

  return catmatMapper.fromJson(json);
};

export const CatmatRepositoryImpl = (): CatmatRepository => ({
  /**
   * Retrieve a Material list by code.
   *
   * @param code
   */
  async getMaterialsByCode(code: string): Promise<Material[]> {
    const catmat = await getCatmat();
    const item = catmat.items.get(code);

    if (!item) {
      return [];
    }

    return [materialMapper.fromCatmatItem(code, item, catmat.groups)];
  },

  /**
   * Retrieve a Material list by description.
   *
   * @param query
   */
  async getMaterialsByDescription(query: string): Promise<Material[]> {
    const catmat = await getCatmat();
    const items: Material[] = [];

    catmat.items.forEach(
      (item, code) => {
        const description = item[1];
        if (hasQuery(description, query)) {
          items.push(materialMapper.fromCatmatItem(code, item, catmat.groups));
        }
      },
    );

    return items;
  },

  /**
   * Retrieve a Material list by group description.
   *
   * @param query
   */
  async getMaterialsByGroupDescription(query: string): Promise<Material[]> {
    const catmat = await getCatmat();
    const groupCodes: string[] = [];

    catmat.groups.forEach(
      (groupDescription, groupCode) => {
        if (hasQuery(groupDescription, query)) {
          groupCodes.push(groupCode);
        }
      },
    );

    if (groupCodes.length === 0) {
      return [];
    }

    const items: Material[] = [];

    catmat.items.forEach(
      (item, code) => {
        const groupCode = item[0];
        if (groupCodes.includes(groupCode)) {
          items.push(materialMapper.fromCatmatItem(code, item, catmat.groups));
        }
      },
    );

    return items;
  },
});

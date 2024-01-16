import { Service } from 'src/features/catalog/types/service';
import { catserMapper } from 'src/features/catalog/repositories/mappers/catser-mapper';
import { hasQuery } from 'src/features/shared/utils/string';
import { Catser } from 'src/features/catalog/types/catser';
import { CatserRepository } from 'src/features/catalog/repositories/catser-repository';
import { serviceMapper } from 'src/features/catalog/repositories/mappers/service-mapper';

const getCatser = async (): Promise<Catser> => {
  const json = (await import('src/features/catalog/assets/catser.min.json')).default;

  return catserMapper.fromJson(json);
};

export const CatserRepositoryImpl = (): CatserRepository => ({
  /**
   * Retrieve a Service list by code.
   *
   * @param code
   */
  async getServicesByCode(code: string): Promise<Service[]> {
    const catser = await getCatser();
    const item = catser.items.get(code);

    if (!item) {
      return [];
    }

    return [serviceMapper.fromCatserItem(code, item, catser.groups)];
  },

  /**
   * Retrieve a Service list by description.
   *
   * @param query
   */
  async getServicesByDescription(query: string): Promise<Service[]> {
    const catser = await getCatser();
    const items: Service[] = [];

    catser.items.forEach(
      (item, code) => {
        const description = item[1];
        if (hasQuery(description, query)) {
          items.push(serviceMapper.fromCatserItem(code, item, catser.groups));
        }
      },
    );

    return items;
  },

  /**
   * Retrieve a Service list by group description.
   *
   * @param query
   */
  async getServicesByGroupDescription(query: string): Promise<Service[]> {
    const catser = await getCatser();
    const groupCodes: string[] = [];

    catser.groups.forEach(
      (groupDescription, groupCode) => {
        if (hasQuery(groupDescription, query)) {
          groupCodes.push(groupCode);
        }
      },
    );

    if (groupCodes.length === 0) {
      return [];
    }

    const items: Service[] = [];

    catser.items.forEach(
      (item, code) => {
        const groupCode = item[0];
        if (groupCodes.includes(groupCode)) {
          items.push(serviceMapper.fromCatserItem(code, item, catser.groups));
        }
      },
    );

    return items;
  },
});

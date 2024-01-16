import { Service } from 'src/features/catalog/types/service';

export const serviceMapper = {
  fromCatserItem(code: string, item: string[], groups: Map<string, string>): Service {
    const [groupCode, description] = item;

    return {
      groupCode,
      groupDescription: groups.get(groupCode) ?? '',
      code,
      description,
    };
  },
};

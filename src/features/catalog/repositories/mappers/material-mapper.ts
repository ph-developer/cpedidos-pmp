import { Material } from 'src/features/catalog/types/material';

export const materialMapper = {
  fromCatmatItem(code: string, item: string[], groups: Map<string, string>): Material {
    const [groupCode, description] = item;

    return {
      groupCode,
      groupDescription: groups.get(groupCode) ?? '',
      code,
      description,
    };
  },
};

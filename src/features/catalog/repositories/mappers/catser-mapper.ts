import { Catser } from 'src/features/catalog/types/catser';

interface CatserJson {
  extraction_date: string;
  groups: {
    [id: string]: string
  },
  items: {
    [id: string]: string[]
  },
}

export const catserMapper = {
  fromJson(json: CatserJson): Catser {
    return {
      extractionDate: json.extraction_date,
      groups: new Map<string, string>(Object.entries(json.groups)),
      items: new Map<string, string[]>(Object.entries(json.items)),
    };
  },
};

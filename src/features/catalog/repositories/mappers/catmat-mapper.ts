import { Catmat } from 'src/features/catalog/types/catmat';

interface CatmatJson {
  extraction_date: string;
  groups: {
    [id: string]: string
  },
  items: {
    [id: string]: string[]
  },
}

export const catmatMapper = {
  fromJson(json: CatmatJson): Catmat {
    return {
      extractionDate: json.extraction_date,
      groups: new Map<string, string>(Object.entries(json.groups)),
      items: new Map<string, string[]>(Object.entries(json.items)),
    };
  },
};

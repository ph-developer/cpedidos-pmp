import { CatalogSearchItemType } from 'src/features/catalog/types/catalog-search-item-type';
import { CatalogSearchType } from 'src/features/catalog/types/catalog-search-type';

export interface CatalogSearchQuery {
  itemType: CatalogSearchItemType,
  type: CatalogSearchType,
  value: string;
}

import { defineStore } from 'pinia';
import { useCatmatRepository } from 'src/features/catalog/repositories/catmat-repository';
import { useCatserRepository } from 'src/features/catalog/repositories/catser-repository';
import { ref } from 'vue';
import { Item } from 'src/features/catalog/types/item';
import { Failure, UnknownError } from 'src/features/shared/errors/failures';
import { CatalogSearchQuery } from 'src/features/catalog/types/catalog-search-query';
import { CatalogSearchItemType } from 'src/features/catalog/types/catalog-search-item-type';
import { CatalogSearchType } from 'src/features/catalog/types/catalog-search-type';

export const useCatalogSearchStore = defineStore(
  'catalogSearch',
  () => {
    // Inject

    const catmatRepository = useCatmatRepository();
    const catserRepository = useCatserRepository();

    // State

    const isLoading = ref(false);
    const isLoaded = ref(false);
    const loadedItems = ref<Item[]>([]);

    const failure = ref<Failure | null>(null);

    // Actions

    const clearSearch = async () => {
      isLoading.value = true;
      isLoaded.value = false;
      loadedItems.value = [];
      failure.value = null;
      isLoading.value = false;
    };

    const searchItems = async (query: CatalogSearchQuery) => {
      isLoading.value = true;
      isLoaded.value = false;
      loadedItems.value = [];
      failure.value = null;

      let searchItemsFn: ((query: string) => Promise<Item[]>) | null = null;

      if (query.itemType === CatalogSearchItemType.MATERIAL) {
        if (query.type === CatalogSearchType.CODE) {
          searchItemsFn = catmatRepository.getMaterialsByCode;
        } else if (query.type === CatalogSearchType.DESCRIPTION) {
          searchItemsFn = catmatRepository.getMaterialsByDescription;
        } else if (query.type === CatalogSearchType.GROUP_DESCRIPTION) {
          searchItemsFn = catmatRepository.getMaterialsByGroupDescription;
        }
      } else if (query.itemType === CatalogSearchItemType.SERVICE) {
        if (query.type === CatalogSearchType.CODE) {
          searchItemsFn = catserRepository.getServicesByCode;
        } else if (query.type === CatalogSearchType.DESCRIPTION) {
          searchItemsFn = catserRepository.getServicesByDescription;
        } else if (query.type === CatalogSearchType.GROUP_DESCRIPTION) {
          searchItemsFn = catserRepository.getServicesByGroupDescription;
        }
      }

      if (searchItemsFn !== null) {
        try {
          loadedItems.value = await searchItemsFn(query.value);
          isLoaded.value = true;
        } catch (e) {
          if (e instanceof Failure) {
            failure.value = e;
          } else {
            failure.value = new UnknownError();
          }
        }
      }

      isLoading.value = false;
    };

    // Return

    return {
      isLoading,
      isLoaded,
      loadedItems,
      failure,
      clearSearch,
      searchItems,
    };
  },
);

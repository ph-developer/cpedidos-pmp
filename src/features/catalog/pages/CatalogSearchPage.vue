<script lang="ts" setup>
import { useCatalogSearchStore } from 'src/features/catalog/stores/catalog-search-store';
import { useNotify } from 'src/features/shared/utils/notify';
import {
  computed, onMounted, reactive, ref, watch,
} from 'vue';
import { CatalogSearchQuery } from 'src/features/catalog/types/catalog-search-query';
import { CatalogSearchItemType } from 'src/features/catalog/types/catalog-search-item-type';
import { CatalogSearchType } from 'src/features/catalog/types/catalog-search-type';
import { matClose, matSearch } from '@quasar/extras/material-icons';
import { QTable } from 'quasar';
import NoResultsAnimation from 'src/features/shared/components/animations/NoResultsAnimation.vue';

const store = useCatalogSearchStore();
const notify = useNotify();

const valueInputRef = ref<HTMLInputElement | null>(null);

const queryForm = reactive<CatalogSearchQuery>({
  itemType: CatalogSearchItemType.MATERIAL,
  type: CatalogSearchType.CODE,
  value: '',
});

const searchItemTypeOptions = Object.values(CatalogSearchItemType);
const searchTypeOptions = Object.values(CatalogSearchType);

const isSearching = computed(() => (
  store.isLoading
));
const isLoaded = computed(() => (
  store.isLoaded
));
const canSearch = computed(() => (
  !store.isLoading
));
const canClear = computed(() => (
  !store.isLoading
  && (
    queryForm.value !== ''
    || queryForm.itemType !== CatalogSearchItemType.MATERIAL
    || queryForm.type !== CatalogSearchType.CODE
  )
));

const items = computed(() => store.loadedItems);

const tableConfig = computed(() => ({
  rowKey: 'code',
  rows: items.value,
  columns: [
    {
      name: 'code',
      align: 'center',
      label: 'Código',
      field: 'code',
      style: 'min-width: 80px',
    },
    {
      name: 'groupDescription',
      align: 'justify',
      label: 'Descrição do Grupo',
      field: 'groupDescription',
      style: 'min-width: 150px',
    },
    {
      name: 'description',
      align: 'justify',
      label: 'Descrição do Item',
      field: 'description',
    },
  ],
}));

const onSearch = () => {
  store.searchItems(queryForm);
};
const onClear = () => {
  queryForm.itemType = CatalogSearchItemType.MATERIAL;
  queryForm.type = CatalogSearchType.CODE;
  queryForm.value = '';
  store.clearSearch();
  valueInputRef.value?.focus();
};

watch(() => store.failure, (failure) => {
  if (failure !== null) {
    notify.error(failure.message);
  }
});

onMounted(async () => {
  await store.clearSearch();
});
</script>

<template>
  <q-page class="q-col-gutter-md" padding>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-select v-model="queryForm.itemType" :disable="!canSearch"
                  :options="searchItemTypeOptions" label="Tipo do Item" outlined stack-label/>
      </div>
      <div class="col">
        <q-select v-model="queryForm.type" :disable="!canSearch" :options="searchTypeOptions"
                  label="Buscar Por" outlined stack-label/>
      </div>
      <div class="col">
        <q-input ref="valueInputRef" v-model="queryForm.value" :disable="!canSearch"
                 :label="queryForm.type" :loading="isSearching" autofocus
                 input-class="text-uppercase" outlined stack-label @keydown.enter="onSearch"/>
      </div>
      <div class="col-auto">
        <q-btn :disable="!canSearch" :icon="matSearch" color="green" label="Buscar" outline
               @click="onSearch"/>
      </div>
      <div class="col-auto">
        <q-btn :disable="!canClear" :icon="matClose" color="primary" label="Limpar" outline
               @click="onClear"/>
      </div>
    </div>

    <div class="row q-col-gutter-md">

      <div v-if="isLoaded && items.length > 0 " class="col">
        <q-table
          :columns="tableConfig.columns"
          :pagination="{
            sortBy: 'code',
            descending: false,
            page: 1,
            rowsPerPage: 20,
          }"
          :pagination-label="(a, b, c) => `${a}-${b} de ${c}`"
          :row-key="tableConfig.rowKey"
          :rows="tableConfig.rows"
          bordered
          flat
          rows-per-page-label="Itens por página:"
          separator="cell"
          wrap-cells
        />
      </div>

      <div v-else-if="isLoaded" class="col text-center">
        <NoResultsAnimation/>
        <span>Não foram encontrados itens que atendem aos critérios de busca informados.</span>
      </div>

    </div>

  </q-page>
</template>

<style scoped>
.q-btn {
  height: 56px;
}
</style>

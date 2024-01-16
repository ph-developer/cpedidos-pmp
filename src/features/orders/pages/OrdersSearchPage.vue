<script lang="ts" setup>
import { useOrdersSearchStore } from 'src/features/orders/stores/orders-search-store';
import { useNotify } from 'src/features/shared/utils/notify';
import {
  computed, onMounted, reactive, ref, watch,
} from 'vue';
import { OrdersSearchType } from 'src/features/orders/types/orders-search-type';
import { matClose, matSearch } from '@quasar/extras/material-icons';
import { QTable } from 'quasar';
import { OrdersSearchQuery } from 'src/features/orders/types/orders-search-query';
import NoResultsAnimation from 'src/features/shared/components/animations/NoResultsAnimation.vue';

const store = useOrdersSearchStore();
const notify = useNotify();

const valueInputRef = ref<HTMLInputElement | null>(null);

const queryForm = reactive<OrdersSearchQuery>({
  type: OrdersSearchType.SEND_DATE,
  value: '',
});

const searchTypeOptions = Object.values(OrdersSearchType);

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
  && (queryForm.value !== '' || queryForm.type !== OrdersSearchType.SEND_DATE)
));

const orders = computed(() => store.loadedOrders);

const tableConfig = computed(() => ({
  rowKey: 'id',
  rows: orders.value.map((order) => ({
    id: `${order.type}_${order.number}`,
    secretary: order.secretary,
    project: order.project,
    description: order.description,
  })),
  columns: [
    {
      name: 'id',
      align: 'center',
      label: '#',
      field: 'id',
      style: 'max-width: 115px',
    },
    {
      name: 'secretary',
      align: 'justify',
      label: 'Secretaria',
      field: 'secretary',
      style: 'max-width: 150px',
    },
    {
      name: 'project',
      align: 'center',
      label: 'Projeto',
      field: 'project',
      style: 'max-width: 100px',
    },
    {
      name: 'description',
      align: 'justify',
      label: 'Descrição',
      field: 'description',
    },
  ],
}));

const onSearch = () => {
  store.searchOrders(queryForm);
};
const onClear = () => {
  queryForm.type = OrdersSearchType.SEND_DATE;
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
        <q-select v-model="queryForm.type" :disable="!canSearch" :options="searchTypeOptions"
                  label="Buscar Por" outlined stack-label/>
      </div>
      <div class="col">
        <q-input ref="valueInputRef" v-model="queryForm.value" :disable="!canSearch"
                 :label="queryForm.type" :loading="isSearching" autofocus
                 input-class="text-uppercase" mask="##/##/####" outlined stack-label
                 @keydown.enter="onSearch"/>
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

      <div v-if="isLoaded && orders.length > 0" class="col">
        <q-table
          :columns="tableConfig.columns"
          :pagination="{
            sortBy: 'id',
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
        >
          <template v-slot:body-cell-id="props">
            <q-td :props="props">
              {{ props.row.id.split('_')[0] }}
              <br>
              {{ props.row.id.split('_')[1] }}
            </q-td>
          </template>
        </q-table>
      </div>

      <div v-else-if="isLoaded" class="col text-center">
        <NoResultsAnimation/>
        <span>Não foram encontrados pedidos que atendem aos critérios de busca informados.</span>
      </div>

    </div>

  </q-page>
</template>

<style scoped>
.q-btn {
  height: 56px;
}
</style>

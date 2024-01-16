<script lang="ts" setup>
import {
  computed, reactive, ref, watch,
} from 'vue';
import { matClose, matSearch } from '@quasar/extras/material-icons';
import { OrderType } from 'src/features/orders/types/order-type';
import { useNotify } from 'src/features/shared/utils/notify';
import { useOrdersPublicStore } from 'src/features/orders/stores/orders-public-store';

const store = useOrdersPublicStore();
const notify = useNotify();

const numberInputRef = ref<HTMLInputElement | null>(null);

const queryForm = reactive({
  number: '',
  type: OrderType.SE,
});

const dataForm = reactive({
  arrivalDate: '',
  secretary: '',
  project: '',
  description: '',
  sendDate: '',
  returnDate: '',
  situation: '',
  notes: '',
});

const typeOptions = Object.values(OrderType);

const isLoading = computed(() => (
  store.isLoading
));
const orderNotFound = computed(() => (
  store.isLoaded && store.loadedOrder === null
));
const isLoaded = computed(() => (
  store.isLoaded
));
const canSearch = computed(() => (
  !store.isLoading && !store.isLoaded
  && queryForm.number !== ''
));
const canClear = computed(() => (
  !store.isLoading && store.isLoaded
));

const onSearch = () => {
  store.searchOrder(queryForm);
};
const onClear = () => {
  queryForm.number = '';
  queryForm.type = OrderType.SE;
  store.clearSearch();
  numberInputRef.value?.focus();
};

watch(() => store.failure, (failure) => {
  if (failure !== null) {
    notify.error(failure.message);
  }
});
watch(() => store.loadedOrder, (order) => {
  dataForm.arrivalDate = order?.arrivalDate ?? '';
  dataForm.secretary = order?.secretary ?? '';
  dataForm.project = order?.project ?? '';
  dataForm.description = order?.description ?? '';
  dataForm.sendDate = order?.sendDate ?? '';
  dataForm.returnDate = order?.returnDate ?? '';
  dataForm.situation = order?.situation ?? '';
  dataForm.notes = order?.notes ?? '';
});
</script>

<template>
  <q-page class="q-col-gutter-md" padding>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input ref="numberInputRef" v-model="queryForm.number" :disable="isLoading"
                 :loading="isLoading" autofocus input-class="text-uppercase" label="Número"
                 outlined stack-label/>
      </div>
      <div class="col">
        <q-select v-model="queryForm.type" :disable="isLoading" :options="typeOptions" label="Tipo"
                  outlined stack-label/>
      </div>
      <div class="col row">
        <div v-if="!isLoaded" class="col-5">
          <q-btn :disable="!canSearch" :icon="matSearch" class="q-mr-md full-width" color="primary"
                 label="Buscar" outline @click="onSearch"/>
        </div>
        <div v-else class="col-5">
          <q-btn :disable="!canClear" :icon="matClose" class="q-mr-md full-width" color="primary"
                 label="Limpar" outline @click="onClear"/>
        </div>
        <div class="col row">
          <span v-if="orderNotFound" class="q-pl-md self-center text-justify">
            Pedido não encontrado.
          </span>
        </div>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.arrivalDate" disable label="Data de Chegada" mask="##/##/####"
                 outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.secretary" disable input-class="text-uppercase"
                 label="Secretaria Requisitante" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.project" disable input-class="text-uppercase" label="Projeto"
                 outlined stack-label/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.description" disable input-class="no-resize text-uppercase"
                 label="Descrição" outlined rows="5" stack-label type="textarea"/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.sendDate" disable label="Data de Envio ao Financeiro"
                 mask="##/##/####" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.returnDate" disable label="Data de Retorno do Financeiro"
                 mask="##/##/####" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.situation" disable input-class="text-uppercase" label="Situação"
                 outlined stack-label/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.notes" disable input-class="no-resize text-uppercase"
                 label="Observações" outlined rows="5" stack-label type="textarea"/>
      </div>
    </div>
  </q-page>
</template>

<style scoped>
.q-btn {
  height: 56px;
}
</style>

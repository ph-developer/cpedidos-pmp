<script lang="ts" setup>
import {
  computed, reactive, ref, watch,
} from 'vue';
import { matClose, matDelete, matSave } from '@quasar/extras/material-icons';
import { OrderType } from 'src/features/orders/types/order-type';
import { useOrdersRegisterStore } from 'src/features/orders/stores/orders-register-store';
import { Order } from 'src/features/orders/types/order';
import { useNotify } from 'src/features/shared/utils/notify';
import { useDialog } from 'src/features/shared/utils/dialog';

const store = useOrdersRegisterStore();
const notify = useNotify();
const dialog = useDialog();

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

const isSearching = computed(() => (
  store.isSearching
));
const isArchived = computed(() => (
  store.loadedOrder?.isArchived ?? false
));
const canSearch = computed(() => (
  !store.isLoading
));
const canChange = computed(() => (
  !(store.isSearching || store.isLoading)
  && store.isLoaded
  && store.loadedOrder?.isArchived !== true
));
const canSave = computed(() => (
  !(store.isSearching || store.isLoading)
  && store.isLoaded
  && store.loadedOrder?.isArchived !== true
));
const canClear = computed(() => (
  !(store.isSearching || store.isLoading)
  && (queryForm.number !== '' || queryForm.type !== OrderType.SE)
));
const canDelete = computed(() => (
  !(store.isSearching || store.isLoading)
  && store.isLoaded
  && store.loadedOrder !== null
  && store.loadedOrder.isArchived !== true
));

const getOrder = () => ({
  ...queryForm,
  ...dataForm,
  isArchived: store?.loadedOrder?.isArchived ?? undefined,
} as Order);

const onSave = () => {
  store.saveOrder(getOrder());
};
const onClear = () => {
  queryForm.number = '';
  queryForm.type = OrderType.SE;
  store.clearSearch();
  numberInputRef.value?.focus();
};
const onDelete = () => {
  dialog.confirm(
    'Excluir pedido?',
    'Deseja realmente excluir este pedido? Esta ação é irreversível.',
    () => {
      store.deleteOrder(getOrder());
    },
  );
};

watch(queryForm, (query) => {
  store.searchOrder(query);
});
watch(() => store.success, (success) => {
  if (success === 'SAVE') {
    notify.success('Pedido salvo com sucesso.');
  } else if (success === 'DELETE') {
    notify.success('Pedido excluído com sucesso.');
  }
});
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
        <q-input ref="numberInputRef" v-model="queryForm.number" :disable="!canSearch"
                 :loading="isSearching" autofocus input-class="text-uppercase" label="Número"
                 outlined stack-label/>
      </div>
      <div class="col">
        <q-select v-model="queryForm.type" :disable="!canSearch" :options="typeOptions" label="Tipo"
                  outlined stack-label/>
      </div>
      <div class="col row">
        <span v-if="isArchived" class="self-center text-justify">
          Este pedido está arquivado e não pode ser alterado.
        </span>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.arrivalDate" :disable="!canChange" label="Data de Chegada"
                 mask="##/##/####" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.secretary" :disable="!canChange" input-class="text-uppercase"
                 label="Secretaria Requisitante" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.project" :disable="!canChange" input-class="text-uppercase"
                 label="Projeto" outlined stack-label/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.description" :disable="!canChange"
                 input-class="no-resize text-uppercase" label="Descrição" outlined rows="5"
                 stack-label type="textarea"/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.sendDate" :disable="!canChange"
                 label="Data de Envio ao Financeiro" mask="##/##/####" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.returnDate" :disable="!canChange"
                 label="Data de Retorno do Financeiro" mask="##/##/####" outlined stack-label/>
      </div>
      <div class="col">
        <q-input v-model="dataForm.situation" :disable="!canChange" input-class="text-uppercase"
                 label="Situação" outlined stack-label/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-input v-model="dataForm.notes" :disable="!canChange"
                 input-class="no-resize text-uppercase" label="Observações" outlined rows="5"
                 stack-label type="textarea"/>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <div class="col">
        <q-btn :disable="!canSave" :icon="matSave" class="q-mr-md" color="green" label="Salvar"
               outline @click="onSave"/>
        <q-btn :disable="!canClear" :icon="matClose" class="q-mr-md" color="primary" label="Limpar"
               outline @click="onClear"/>
        <q-btn :disable="!canDelete" :icon="matDelete" color="red" label="Excluir" outline
               @click="onDelete"/>
      </div>
    </div>
  </q-page>
</template>

<style scoped>
.q-btn {
  height: 56px;
}
</style>

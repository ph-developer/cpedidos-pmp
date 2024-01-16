<script lang="ts" setup>
import {
  matEditNote,
  matLogout,
  matManageSearch,
  matMenuBook,
} from '@quasar/extras/material-icons';
import { computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from 'src/features/auth/stores/auth-store';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();

const routeInfos = [
  {
    path: '/pedidos/cadastro',
    icon: matEditNote,
    description: 'Cadastro de Pedidos',
  },
  {
    path: '/pedidos/busca',
    icon: matManageSearch,
    description: 'Busca de Pedidos',
  },
  {
    path: '/catalogo/busca',
    icon: matMenuBook,
    description: 'Busca de Materiais e Serviços',
  },
];

const loggedUser = computed(
  () => authStore.loggedUser,
);
const currentRouteInfo = computed(
  () => routeInfos.find((routeInfo) => routeInfo.path === route.path) ?? null,
);
const availableRouteLinks = computed(
  () => routeInfos.filter((routeInfo) => routeInfo.path !== route.path),
);

const onLogout = () => {
  authStore.doLogout()
    .then(() => {
      router.replace('/auth/login');
    });
};
</script>

<template>
  <q-layout view="hHh lpR fFf">

    <q-header class="bg-white text-primary q-pa-xs shadow-1">
      <q-toolbar>
        <q-toolbar-title v-if="currentRouteInfo !== null">
          <q-icon :name="currentRouteInfo?.icon" class="q-mr-md"/>
          <span class="text-bold">{{ currentRouteInfo?.description }}</span>
        </q-toolbar-title>

        <span class="q-mr-md text-bold">{{ loggedUser?.email || '' }}</span>

        <q-btn v-for="link in availableRouteLinks" :key="link.path" :icon="link.icon"
               :to="link.path" class="q-mr-md" dense flat round>
          <q-tooltip>{{ link.description }}</q-tooltip>
        </q-btn>
        <q-btn :icon="matLogout" dense flat round @click="onLogout">
          <q-tooltip>Sair</q-tooltip>
        </q-btn>
      </q-toolbar>
    </q-header>

    <q-page-container class="container q-mx-auto">
      <router-view/>
    </q-page-container>

  </q-layout>
</template>

<style scoped>
.container {
  max-width: 1140px;
}
</style>

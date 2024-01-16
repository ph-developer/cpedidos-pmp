<script lang="ts" setup>
import { matSearch } from '@quasar/extras/material-icons';
</script>

<template>
  <q-layout view="hHh lpR fFf">

    <q-header class="bg-white text-primary q-pa-xs shadow-1">
      <q-toolbar>
        <q-toolbar-title>
          <q-icon :name="matSearch" class="q-mr-md"/>
          <span class="text-bold">Busca de Pedidos (Público)</span>
        </q-toolbar-title>
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

<script lang="ts" setup>

import NotFoundAnimation from 'src/features/shared/components/animations/NotFoundAnimation.vue';
import { matArrowBack } from '@quasar/extras/material-icons';
</script>

<template>
  <div class="fullscreen text-center q-pa-md flex flex-center">
    <div>
      <div>
        <NotFoundAnimation/>
      </div>

      <div class="text-h4">
        Oops. Esta página não existe...
      </div>

      <q-btn :icon="matArrowBack" class="q-mt-xl" color="primary" label="Voltar ao Início" outline
             text-color="primary" to="/"/>
    </div>
  </div>
</template>

<style scoped>
.text-h4 {
  opacity: .4;
}

.q-btn {
  height: 56px;
}
</style>

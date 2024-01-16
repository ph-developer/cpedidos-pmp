<script lang="ts" setup>
import CartLoaderAnimation from 'src/features/shared/components/animations/CartLoaderAnimation.vue';
import { useAuthStore } from 'src/features/auth/stores/auth-store';
import { onMounted, ref } from 'vue';
import { sleep } from 'src/features/shared/utils/sleep';

const authStore = useAuthStore();

const isLoaded = ref(false);

onMounted(async () => {
  await sleep(1500);
  await authStore.fetchLoggedUser();
  isLoaded.value = true;
});
</script>

<template>
  <div>

    <div v-if="isLoaded">
      <slot/>
    </div>

    <div v-else class="fullscreen text-center q-pa-md flex flex-center">
      <CartLoaderAnimation/>
    </div>

  </div>
</template>

<style scoped>

</style>

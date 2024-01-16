<script lang="ts" setup>
import { matLock, matLockOpen, matLogin } from '@quasar/extras/material-icons';
import {
  computed, reactive, ref, watch,
} from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from 'src/features/auth/stores/auth-store';
import { useNotify } from 'src/features/shared/utils/notify';

const route = useRoute();
const router = useRouter();
const store = useAuthStore();
const notify = useNotify();

const form = reactive({
  email: '',
  password: '',
});
const showPassword = ref(false);

const isLoading = computed(() => (
  store.isLoading
));

const canChange = computed(() => (
  !store.isLoading
));
const canSubmit = computed(() => (
  !store.isLoading
));

const onSubmit = () => {
  store.doLogin(form.email, form.password);
};
const onToggleShowPassword = () => {
  showPassword.value = !showPassword.value;
};

watch(() => store.failure, (failure) => {
  if (failure !== null) {
    notify.error(failure.message);
  }
});

watch(() => store.loggedUser, (loggedUser) => {
  if (loggedUser !== null) {
    const redirectTo = route.query.redirect as string ?? '/';
    router.replace(redirectTo);
  }
});
</script>

<template>
  <q-page class="fullscreen text-center q-pa-md flex flex-center">

    <q-card class="w-400" flat>
      <q-card-section class="column items-center q-col-gutter-md">

        <div class="col">
          <img alt="Controle de Pedidos" height="70" src="../../shared/assets/logo.svg"/>
        </div>

        <div class="col full-width">
          <q-input v-model="form.email" :disable="!canChange" autofocus label="Email" outlined
                   @keydown.enter="onSubmit"/>
        </div>

        <div class="col full-width">
          <q-input v-model="form.password" :disable="!canChange"
                   :type="showPassword ? 'text': 'password'" label="Senha" outlined
                   @keydown.enter="onSubmit">
            <template v-slot:append>
              <q-btn :icon="showPassword ? matLockOpen : matLock" dense flat round
                     @click="onToggleShowPassword"/>
            </template>
          </q-input>
        </div>

        <div class="col">
          <q-btn :disable="!canSubmit" :icon="matLogin" :loading="isLoading" color="primary"
                 label="Entrar" outline @click="onSubmit"/>
        </div>

      </q-card-section>
    </q-card>

  </q-page>
</template>

<style scoped>
.w-400 {
  width: 400px;
}

.q-btn--outline {
  height: 56px;
}
</style>

import { defineStore } from 'pinia';
import { User } from 'src/features/auth/types/user';
import { ref } from 'vue';
import { Failure, UnknownError } from 'src/features/shared/errors/failures';
import { useAuthRepository } from 'src/features/auth/repositories/auth-repository';

export const useAuthStore = defineStore(
  'auth',
  () => {
    // Inject

    const authRepository = useAuthRepository();

    // State

    const isLoading = ref(false);
    const loggedUser = ref<User | null>(null);

    const failure = ref<Failure | null>(null);

    // Actions

    const fetchLoggedUser = async () => {
      isLoading.value = true;

      try {
        loggedUser.value = await authRepository.getCurrentUser();
      } catch (e) {
        loggedUser.value = null;
      }

      isLoading.value = false;
    };

    const doLogin = async (email: string, password: string) => {
      isLoading.value = true;
      failure.value = null;

      try {
        loggedUser.value = await authRepository.doLogin(email, password);
      } catch (e) {
        if (e instanceof Failure) {
          failure.value = e;
        } else {
          failure.value = new UnknownError();
        }
      }

      isLoading.value = false;
    };

    const doLogout = async () => {
      isLoading.value = true;
      failure.value = null;

      try {
        await authRepository.doLogout();
        loggedUser.value = null;
      } catch (e) {
        if (e instanceof Failure) {
          failure.value = e;
        } else {
          failure.value = new UnknownError();
        }
      }

      isLoading.value = false;
    };

    // Return

    return {
      isLoading,
      loggedUser,
      failure,
      fetchLoggedUser,
      doLogin,
      doLogout,
    };
  },
);

import { Router } from 'vue-router';
import { useAuthRepository } from 'src/features/auth/repositories/auth-repository';

export const authGuard = (router: Router, redirectTo: string) => {
  router.beforeEach(async (to) => {
    if (!to.meta.requiresAuth) {
      return true;
    }

    const authRepository = useAuthRepository();

    try {
      await authRepository.getCurrentUser();
      return true;
    } catch (e) {
      return {
        path: redirectTo,
        query: {
          redirect: to.fullPath,
        },
      };
    }
  });
};

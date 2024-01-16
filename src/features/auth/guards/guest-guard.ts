import { Router } from 'vue-router';
import { useAuthRepository } from 'src/features/auth/repositories/auth-repository';

export const guestGuard = (router: Router, redirectTo: string) => {
  router.beforeEach(async (to) => {
    if (!to.meta.requiresGuest) {
      return true;
    }

    const authRepository = useAuthRepository();

    try {
      await authRepository.getCurrentUser();
      return {
        path: redirectTo,
        query: {
          redirect: to.fullPath,
        },
      };
    } catch (e) {
      return true;
    }
  });
};

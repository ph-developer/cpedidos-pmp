import { Router } from 'vue-router';
import { authGuard } from 'src/features/auth/guards/auth-guard';
import { guestGuard } from 'src/features/auth/guards/guest-guard';

export const setupGuards = (router: Router) => {
  authGuard(router, '/auth/login');
  guestGuard(router, '/pedidos/cadastro');
};

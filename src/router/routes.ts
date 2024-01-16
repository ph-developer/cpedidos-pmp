import { RouteRecordRaw } from 'vue-router';
import { ordersPublicRoutes, ordersRoutes } from 'src/features/orders/routes';
import { catalogRoutes } from 'src/features/catalog/routes';
import { authRoutes } from 'src/features/auth/routes';

const routes: RouteRecordRaw[] = [
  {
    path: '/auth',
    component: () => import('src/features/shared/layouts/EmptyLayout.vue'),
    children: authRoutes,
    meta: { requiresGuest: true },
  },
  {
    path: '/pedidos',
    component: () => import('src/features/shared/layouts/MainLayout.vue'),
    children: ordersRoutes,
    meta: { requiresAuth: true },
  },
  {
    path: '/publico/pedidos',
    component: () => import('src/features/shared/layouts/PublicLayout.vue'),
    children: ordersPublicRoutes,
    meta: { requiresGuest: true },
  },
  {
    path: '/catalogo',
    component: () => import('src/features/shared/layouts/MainLayout.vue'),
    children: catalogRoutes,
    meta: { requiresAuth: true },
  },
  {
    path: '/',
    redirect: '/pedidos',
  },
  {
    path: '/:catchAll(.*)*',
    component: () => import('src/features/shared/pages/ErrorNotFound.vue'),
  },
];

export default routes;

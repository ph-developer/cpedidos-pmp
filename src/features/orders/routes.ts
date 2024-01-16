import { RouteRecordRaw } from 'vue-router';

export const ordersRoutes: RouteRecordRaw[] = [
  {
    path: '',
    redirect: '/pedidos/cadastro',
  },
  {
    path: 'cadastro',
    component: () => import('./pages/OrdersRegisterPage.vue'),
  },
  {
    path: 'busca',
    component: () => import('./pages/OrdersSearchPage.vue'),
  },
];

export const ordersPublicRoutes: RouteRecordRaw[] = [
  {
    path: 'busca',
    component: () => import('./pages/OrdersPublicPage.vue'),
  },
];

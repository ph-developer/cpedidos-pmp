import { RouteRecordRaw } from 'vue-router';

export const catalogRoutes: RouteRecordRaw[] = [
  {
    path: '',
    redirect: '/catalogo/busca',
  },
  {
    path: 'busca',
    component: () => import('./pages/CatalogSearchPage.vue'),
  },
];

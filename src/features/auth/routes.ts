import { RouteRecordRaw } from 'vue-router';

export const authRoutes: RouteRecordRaw[] = [
  {
    path: 'login',
    component: () => import('./pages/LoginPage.vue'),
  },
];

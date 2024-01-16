import { OrdersSearchType } from 'src/features/orders/types/orders-search-type';

export interface OrdersSearchQuery {
  type: OrdersSearchType;
  value: string;
}

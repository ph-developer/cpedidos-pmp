import { OrderType } from 'src/features/orders/types/order-type';

export interface OrderQuery {
  number: string;
  type: OrderType;
}

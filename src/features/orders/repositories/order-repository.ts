import { OrderType } from 'src/features/orders/types/order-type';
import { Order } from 'src/features/orders/types/order';
import { OrderRepositoryImpl } from 'src/features/orders/repositories/order-repository-impl';
import {
  OrderRepositoryValidatorDecorator,
} from 'src/features/orders/repositories/decorators/order-repository-validator-decorator';
import {
  OrderRepositoryArchiveDecorator,
} from 'src/features/orders/repositories/decorators/order-repository-archive-decorator';

export interface OrderRepository {
  /**
   * Retrieve from DB an order by type and number.
   *
   * @param type
   * @param number
   * @throws OrderNotFound
   */
  getOrderByTypeAndNumber: (type: OrderType, number: string) => Promise<Order>;

  /**
   * Retrieve from DB an orders list by send date.
   *
   * @param sendDate
   */
  getAllOrdersBySendDate: (sendDate: string) => Promise<Order[]>;

  /**
   * Retrieve from DB an orders list by arrival date.
   *
   * @param sendDate
   */
  getAllOrdersByArrivalDate: (arrivalDate: string) => Promise<Order[]>;

  /**
   * Save or update an order in DB.
   *
   * @param order
   */
  saveOrder: (order: Order) => Promise<Order>;

  /**
   * Delete an order in DB.
   *
   * @param order
   */
  deleteOrder: (order: Order) => Promise<void>;
}

export const useOrderRepository = (): OrderRepository => OrderRepositoryValidatorDecorator(
  OrderRepositoryArchiveDecorator(
    OrderRepositoryImpl(),
  ),
);

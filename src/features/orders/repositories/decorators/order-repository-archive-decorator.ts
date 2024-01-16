import { OrderRepository } from 'src/features/orders/repositories/order-repository';
import { OrderType } from 'src/features/orders/types/order-type';
import { Order } from 'src/features/orders/types/order';
import { OrderNotFound } from 'src/features/orders/errors/order-failures';
import { get, getDatabase, ref } from 'firebase/database';
import { orderMapper } from 'src/features/orders/repositories/mappers/order-mapper';

const getArchivedOrderByTypeAndNumber = async (year: string, id: string): Promise<Order | null> => {
  const db = getDatabase();
  const orderRef = ref(db, `archive/orders/${year}/${id}`);
  const orderSnapshot = await get(orderRef);

  if (!orderSnapshot.exists()) {
    return null;
  }

  const order = orderMapper.fromDataSnapshot(orderSnapshot);
  order.isArchived = true;

  return order;
};

export const OrderRepositoryArchiveDecorator = (
  decorated: OrderRepository,
): OrderRepository => ({
  ...decorated,

  async getOrderByTypeAndNumber(type: OrderType, number: string): Promise<Order> {
    try {
      return await decorated.getOrderByTypeAndNumber(type, number);
    } catch (e) {
      if (e instanceof OrderNotFound) {
        const orderId = `${type}_${number}`;
        const currentYear = new Date().getFullYear();
        const years = Array.from(
          { length: currentYear - 2020 },
          (_, index) => (2021 + index).toString(),
        );
        const archivedOrders = await Promise.all(
          years.map((year) => getArchivedOrderByTypeAndNumber(year, orderId)),
        );
        const order = archivedOrders.find((archivedOrder) => !!archivedOrder) ?? null;

        if (order !== null) {
          return order;
        }
      }

      throw e;
    }
  },
});

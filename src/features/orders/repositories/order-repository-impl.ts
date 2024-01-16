import { OrderRepository } from 'src/features/orders/repositories/order-repository';
import { Order } from 'src/features/orders/types/order';
import { OrderType } from 'src/features/orders/types/order-type';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  getFirestore,
  query,
  setDoc,
  where,
} from 'firebase/firestore';
import { OrderNotFound } from 'src/features/orders/errors/order-failures';
import { orderMapper } from 'src/features/orders/repositories/mappers/order-mapper';

export const OrderRepositoryImpl = (): OrderRepository => ({
  /**
   * Retrieve from Firestore an order by type and number.
   *
   * @param type
   * @param number
   * @throws OrderNotFound
   */
  async getOrderByTypeAndNumber(type: OrderType, number: string): Promise<Order> {
    const firestore = getFirestore();
    const orderId = `${type}_${number}`;
    const ordersCollection = collection(firestore, 'orders');
    const orderDoc = doc(ordersCollection, orderId);
    const orderSnapshot = await getDoc(orderDoc);

    if (!orderSnapshot.exists()) {
      throw new OrderNotFound();
    }

    const orderData = orderSnapshot.data();

    return orderMapper.fromDocumentData(orderData);
  },

  /**
   * Retrieve from Firestore an orders list by send date.
   *
   * @param sendDate
   */
  async getAllOrdersBySendDate(sendDate: string): Promise<Order[]> {
    const firestore = getFirestore();
    const ordersCollection = collection(firestore, 'orders');
    const ordersQuery = query(ordersCollection, where('sendDate', '==', sendDate));
    const ordersSnapshot = await getDocs(ordersQuery);
    const ordersDocs = ordersSnapshot.docs;

    return ordersDocs
      .map((orderSnapshot) => orderSnapshot.data())
      .map((orderData) => orderMapper.fromDocumentData(orderData));
  },

  /**
   * Retrieve from Firestore an orders list by arrival date.
   *
   * @param arrivalDate
   */
  async getAllOrdersByArrivalDate(arrivalDate: string): Promise<Order[]> {
    const firestore = getFirestore();
    const ordersCollection = collection(firestore, 'orders');
    const ordersQuery = query(ordersCollection, where('arrivalDate', '==', arrivalDate));
    const ordersSnapshot = await getDocs(ordersQuery);
    const ordersDocs = ordersSnapshot.docs;

    return ordersDocs
      .map((orderSnapshot) => orderSnapshot.data())
      .map((orderData) => orderMapper.fromDocumentData(orderData));
  },

  /**
   * Save or update an order in Firestore.
   *
   * @param order
   */
  async saveOrder(order: Order): Promise<Order> {
    const firestore = getFirestore();
    const orderId = `${order.type}_${order.number}`;
    const ordersCollection = collection(firestore, 'orders');
    const orderDoc = doc(ordersCollection, orderId);
    const orderData = orderMapper.toDocumentData(order);

    await setDoc(orderDoc, orderData);

    return order;
  },

  /**
   * Delete an order in Firestore.
   *
   * @param order
   */
  async deleteOrder(order: Order): Promise<void> {
    const firestore = getFirestore();
    const orderId = `${order.type}_${order.number}`;
    const ordersCollection = collection(firestore, 'orders');
    const orderDoc = doc(ordersCollection, orderId);

    await deleteDoc(orderDoc);
  },
});

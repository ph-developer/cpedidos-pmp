import { DocumentData } from 'firebase/firestore';
import { Order } from 'src/features/orders/types/order';
import { OrderType } from 'src/features/orders/types/order-type';
import { DataSnapshot } from 'firebase/database';

export const orderMapper = {
  /**
   * Map a DataSnapshot to Order.
   *
   * @param dataSnapshot
   */
  fromDataSnapshot(dataSnapshot: DataSnapshot): Order {
    const val = dataSnapshot.val();
    return {
      number: val.number?.toUpperCase(),
      type: OrderType[val.type as keyof typeof OrderType],
      arrivalDate: val.arrivalDate,
      secretary: val.secretary?.toUpperCase(),
      project: val.project?.toUpperCase(),
      description: val.description?.toUpperCase(),
      sendDate: val.sendDate,
      returnDate: val.returnDate,
      situation: val.situation?.toUpperCase(),
      notes: val.notes?.toUpperCase(),
      isArchived: val.isArchived ?? false,
    };
  },

  /**
   * Map a DocumentData to Order.
   *
   * @param documentData
   */
  fromDocumentData(documentData: DocumentData): Order {
    return {
      number: documentData.number?.toUpperCase(),
      type: OrderType[documentData.type as keyof typeof OrderType],
      arrivalDate: documentData.arrivalDate,
      secretary: documentData.secretary?.toUpperCase(),
      project: documentData.project?.toUpperCase(),
      description: documentData.description?.toUpperCase(),
      sendDate: documentData.sendDate,
      returnDate: documentData.returnDate,
      situation: documentData.situation?.toUpperCase(),
      notes: documentData.notes?.toUpperCase(),
      isArchived: documentData.isArchived ?? false,
    };
  },

  /**
   * Map an Order to DocumentData.
   *
   * @param order
   */
  toDocumentData(order: Order): DocumentData {
    return {
      number: order.number?.toUpperCase(),
      type: order.type,
      arrivalDate: order.arrivalDate,
      secretary: order.secretary?.toUpperCase(),
      project: order.project?.toUpperCase(),
      description: order.description?.toUpperCase(),
      sendDate: order.sendDate,
      returnDate: order.returnDate,
      situation: order.situation?.toUpperCase(),
      notes: order.notes?.toUpperCase(),
    };
  },
};

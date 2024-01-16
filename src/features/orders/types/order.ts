import { OrderType } from 'src/features/orders/types/order-type';

export interface Order {
  number: string;
  type: OrderType;
  arrivalDate: string;
  secretary: string;
  project: string;
  description: string;
  sendDate: string;
  returnDate: string;
  situation: string;
  notes: string;
  isArchived?: boolean;
}

export const emptyOrder = (): Order => ({
  number: '',
  type: OrderType.SE,
  arrivalDate: '',
  secretary: '',
  project: '',
  description: '',
  sendDate: '',
  returnDate: '',
  situation: '',
  notes: '',
});

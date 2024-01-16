import { OrderRepository } from 'src/features/orders/repositories/order-repository';
import { OrderType } from 'src/features/orders/types/order-type';
import { Order } from 'src/features/orders/types/order';
import { InvalidInput } from 'src/features/orders/errors/order-failures';
import moment, { Moment } from 'moment/moment';

export const OrderRepositoryValidatorDecorator = (
  decorated: OrderRepository,
): OrderRepository => ({
  ...decorated,

  /**
   * Validate arguments and return decorated method.
   *
   * @param type
   * @param number
   * @throws InvalidInput
   */
  async getOrderByTypeAndNumber(type: OrderType, number: string): Promise<Order> {
    if (number === '') {
      throw new InvalidInput('O campo "número" deve ser preenchido.');
    }
    if (type.toString() === '') {
      throw new InvalidInput('O campo "tipo" deve ser preenchido.');
    }
    return decorated.getOrderByTypeAndNumber(type, number);
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param sendDate
   * @throws InvalidInput
   */
  async getAllOrdersBySendDate(sendDate: string): Promise<Order[]> {
    if (sendDate === '') {
      throw new InvalidInput('O campo "data de envio" deve ser preenchido.');
    }
    return decorated.getAllOrdersBySendDate(sendDate);
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param arrivalDate
   * @throws InvalidInput
   */
  async getAllOrdersByArrivalDate(arrivalDate: string): Promise<Order[]> {
    if (arrivalDate === '') {
      throw new InvalidInput('O campo "data de chegada" deve ser preenchido.');
    }
    return decorated.getAllOrdersByArrivalDate(arrivalDate);
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param order
   * @throws InvalidInput
   */
  async saveOrder(order: Order): Promise<Order> {
    const currentDate = moment();
    const arrivalDate = moment(order.arrivalDate, 'DD/MM/YYYY', true);
    let sendDate: Moment | null = null;
    let returnDate: Moment | null = null;

    if (order.isArchived) {
      throw new InvalidInput('Este pedido está arquivado e não pode receber alterações.');
    }
    if (order.number === '') {
      throw new InvalidInput('O campo "número" deve ser preenchido.');
    }
    if (order.type.toString() === '') {
      throw new InvalidInput('O campo "tipo" deve ser preenchido.');
    }
    if (order.arrivalDate === '') {
      throw new InvalidInput('O campo "data de chegada" deve ser preenchido.');
    }
    if (order.secretary === '') {
      throw new InvalidInput('O campo "secretaria" deve ser preenchido.');
    }
    if (order.project === '') {
      throw new InvalidInput('O campo "projeto" deve ser preenchido.');
    }
    if (order.description === '') {
      throw new InvalidInput('O campo "descrição" deve ser preenchido.');
    }
    if (order.sendDate === '' && order.returnDate !== '') {
      throw new InvalidInput(
        'O campo "data de retorno do financeiro" não deve ser preenchido quando o campo '
        + '"data de envio ao financeiro" não estiver preenchido.',
      );
    }
    if (!arrivalDate.isValid()) {
      throw new InvalidInput(
        'O campo "data de chegada" não possui uma data válida.',
      );
    }
    if (order.sendDate !== '') {
      sendDate = moment(order.sendDate, 'DD/MM/YYYY', true);
      if (!sendDate.isValid()) {
        throw new InvalidInput(
          'O campo "data de envio ao financeiro" não possui uma data válida.',
        );
      }
    }
    if (order.returnDate !== '') {
      returnDate = moment(order.returnDate, 'DD/MM/YYYY', true);
      if (!returnDate.isValid()) {
        throw new InvalidInput(
          'O campo "data de retorno do financeiro" não possui uma data válida.',
        );
      }
    }
    if (arrivalDate.isAfter(currentDate, 'day')) {
      throw new InvalidInput(
        'O campo "data de chegada" deve possuir uma data igual ou inferior ao dia atual.',
      );
    }
    if (sendDate?.isAfter(currentDate, 'day')) {
      throw new InvalidInput(
        'O campo "data de envio ao financeiro" deve possuir uma data igual ou inferior ao dia '
        + 'atual.',
      );
    }
    if (sendDate?.isAfter(currentDate, 'day')) {
      throw new InvalidInput(
        'O campo "data de retorno do financeiro" deve possuir uma data igual ou inferior ao dia '
        + 'atual.',
      );
    }
    if (sendDate?.isBefore(arrivalDate, 'day')) {
      throw new InvalidInput(
        'O campo "data de chegada" deve possuir uma data igual ou inferior à "data de envio ao '
        + 'financeiro".',
      );
    }
    if (sendDate !== null && returnDate?.isBefore(sendDate, 'day')) {
      throw new InvalidInput(
        'O campo "data de envio ao financeiro" deve possuir uma data igual ou inferior à "data '
        + 'de retorno do financeiro".',
      );
    }
    if (arrivalDate.year() < 2020) {
      throw new InvalidInput(
        'O campo "data de chegada" não pode possuir um ano inferior à 2020.',
      );
    }
    return decorated.saveOrder(order);
  },

  /**
   * Validate arguments and return decorated method.
   *
   * @param order
   * @throws InvalidInput
   */
  async deleteOrder(order: Order): Promise<void> {
    if (order.isArchived) {
      throw new InvalidInput('Este pedido está arquivado e não pode receber alterações.');
    }
    if (order.number === '') {
      throw new InvalidInput('O campo "número" deve ser preenchido.');
    }
    if (order.type.toString() === '') {
      throw new InvalidInput('O campo "tipo" deve ser preenchido.');
    }
    return decorated.deleteOrder(order);
  },
});

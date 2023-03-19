import '../../domain/entities/order.dart';
import '../../infra/datasources/order_datasource.dart';

class OrderDatasourceDecorator implements IOrderDatasource {
  final IOrderDatasource _decoratee;

  OrderDatasourceDecorator(this._decoratee);

  @override
  Future<Order> getOrderByTypeAndNumber(String type, String number) async {
    return _decoratee.getOrderByTypeAndNumber(type, number);
  }

  @override
  Future<List<Order>> getAllOrdersBySendDate(String sendDate) async {
    return _decoratee.getAllOrdersBySendDate(sendDate);
  }

  @override
  Future<List<Order>> getAllOrdersByArrivalDate(String arrivalDate) async {
    return _decoratee.getAllOrdersByArrivalDate(arrivalDate);
  }

  @override
  Future<Order> saveOrder(Order order) async {
    return _decoratee.saveOrder(order);
  }

  @override
  Future<bool> deleteOrder(Order order) async {
    return _decoratee.deleteOrder(order);
  }
}

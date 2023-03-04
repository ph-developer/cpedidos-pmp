import '../../domain/entities/order.dart';
import '../../infra/datasources/order_datasource.dart';

class OrderDatasourceDecorator implements IOrderDatasource {
  final IOrderDatasource _orderDatasource;

  OrderDatasourceDecorator(this._orderDatasource);

  @override
  Future<Order> getOrderByTypeAndNumber(String type, String number) async {
    return _orderDatasource.getOrderByTypeAndNumber(type, number);
  }

  @override
  Future<List<Order>> getAllOrdersBySendDate(String sendDate) async {
    return _orderDatasource.getAllOrdersBySendDate(sendDate);
  }

  @override
  Future<List<Order>> getAllOrdersByArrivalDate(String arrivalDate) async {
    return _orderDatasource.getAllOrdersByArrivalDate(arrivalDate);
  }

  @override
  Future<Order> saveOrder(Order order) async {
    return _orderDatasource.saveOrder(order);
  }

  @override
  Future<bool> deleteOrder(Order order) async {
    return _orderDatasource.deleteOrder(order);
  }
}
